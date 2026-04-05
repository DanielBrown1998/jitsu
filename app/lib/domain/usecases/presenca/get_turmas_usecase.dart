import 'package:result_dart/result_dart.dart';

import '../../entities/turma.dart';
import '../../repositories/turma/i_turma_repository.dart';

enum GetTurmasScope { admin, professor }

class GetTurmasParams {
  final List<String>? turmaIds;
  final GetTurmasScope scope;
  final String? professorId;

  const GetTurmasParams({
    this.turmaIds,
    this.scope = GetTurmasScope.admin,
    this.professorId,
  });
}

class GetTurmasException implements Exception {
  final String message;
  GetTurmasException(this.message);

  @override
  String toString() => 'GetTurmasException: $message';
}

abstract class GetTurmasUsecase {
  AsyncResult<List<Turma>> call(GetTurmasParams? params);
}

/// Use Case: Listar Turmas
class GetTurmasUseCaseImpl implements GetTurmasUsecase {
  final TurmaRepository _repository;

  GetTurmasUseCaseImpl(this._repository);

  @override
  AsyncResult<List<Turma>> call(GetTurmasParams? params) async {
    final isProfessorScope = params?.scope == GetTurmasScope.professor;
    final professorId = params?.professorId?.trim();

    if (isProfessorScope && (professorId == null || professorId.isEmpty)) {
      return Failure(
        GetTurmasException(
          'professorId e obrigatorio para listar turmas no escopo de professor.',
        ),
      );
    }

    final turmasResult =
        (params?.turmaIds != null && params!.turmaIds!.isNotEmpty)
        ? await _repository.getByIds(params.turmaIds!)
        : await _repository.getAll();

    return turmasResult.fold(
      (turmas) {
        if (isProfessorScope) {
          final turmasDoProfessor = turmas
              .where((turma) => turma.professorId == professorId)
              .toList();
          return Success(turmasDoProfessor);
        }

        return Success(turmas);
      },
      (error) => Failure(
        GetTurmasException('Erro ao listar turmas: ${error.toString()}'),
      ),
    );
  }
}
