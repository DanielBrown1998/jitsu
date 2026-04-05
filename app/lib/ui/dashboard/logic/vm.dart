import 'package:app/domain/entities/entities.dart';
import 'package:app/domain/entities/turma.dart';
import 'package:app/domain/usecases/presenca/get_turmas_usecase.dart';
import 'package:app/ui/auth/logic/state.dart';
import 'package:flutter/material.dart';

import 'command.dart';
import 'state.dart';

class DashboardVm extends ChangeNotifier {
  final GetTurmasUsecase getTurmasUsecase;

  final DashboardState state = DashboardState(
    isLoading: false,
    error: null,
    hasLoaded: false,
    turmas: const [],
    classes: const [],
    totalTurmasAtivas: 0,
    aulasHoje: 0,
  );

  late final LoadDashboardCommand loadDashboardCommand;

  DashboardVm({required this.getTurmasUsecase}) {
    loadDashboardCommand = LoadDashboardCommand(_loadDashboard);
  }

  Future<void> _loadDashboard(LoadDashboardInput input) async {
    final scope = _toScope(input.role);
    if (scope == null) {
      state.emit(
        isLoading: false,
        hasLoaded: true,
        turmas: const [],
        classes: const [],
        totalTurmasAtivas: 0,
        aulasHoje: 0,
        error: 'Perfil sem acesso ao dashboard.',
      );
      notifyListeners();
      return;
    }

    state.emit(isLoading: true, clearError: true);
    notifyListeners();

    final result = await getTurmasUsecase(
      GetTurmasParams(
        scope: scope,
        professorId: input.professorId,
        turmaIds: input.turmaIds,
      ),
    );

    result.fold(
      (turmas) {
        final sorted = [...turmas]
          ..sort(
            (a, b) => _parseHorarioMinutes(
              a.horarioPadrao,
            ).compareTo(_parseHorarioMinutes(b.horarioPadrao)),
          );
        final weekday = DateTime.now().weekday;
        final turmasDeHoje = sorted
            .where((turma) => turma.ocorreNoDia(weekday))
            .toList();

        state.emit(
          isLoading: false,
          hasLoaded: true,
          clearError: true,
          turmas: sorted,
          classes: _toClassItems(turmasDeHoje, input),
          totalTurmasAtivas: sorted.length,
          aulasHoje: turmasDeHoje.length,
        );
        notifyListeners();
      },
      (error) {
        state.emit(
          isLoading: false,
          hasLoaded: true,
          turmas: const [],
          classes: const [],
          totalTurmasAtivas: 0,
          aulasHoje: 0,
          error: error.toString(),
        );
        notifyListeners();
      },
    );
  }

  GetTurmasScope? _toScope(UserRole role) {
    return switch (role) {
      UserRole.admin => GetTurmasScope.admin,
      UserRole.professor => GetTurmasScope.professor,
      UserRole.student => null,
    };
  }

  List<DashboardClassItem> _toClassItems(
    List<Turma> turmas,
    LoadDashboardInput input,
  ) {
    return turmas
        .map(
          (turma) => DashboardClassItem(
            time: turma.horarioPadrao,
            name: turma.nome,
            instructorAndType:
                '${_resolveInstructorLabel(input, turma)} • ${_tipoToLabel(turma.tipoDeTurma)}',
            studentsLabel: 'Turma ativa',
          ),
        )
        .toList();
  }

  String _resolveInstructorLabel(LoadDashboardInput input, Turma turma) {
    if (input.role == UserRole.professor) {
      return input.professorName ?? 'Professor';
    }
    return 'Professor ${turma.professorId}';
  }

  int _parseHorarioMinutes(String horario) {
    final parts = horario.split(':');
    if (parts.length != 2) return 0;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  String _tipoToLabel(TipoDeTurma tipo) => tipo.getDisplayName(tipo);
}
