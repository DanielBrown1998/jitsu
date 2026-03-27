import 'package:result_dart/result_dart.dart';

import '../../entities/aula_realizada.dart';
import '../../entities/historico_presenca.dart';
import '../../repositories/aluno/i_aluno_repository.dart';
import '../../repositories/aula/i_aula_repository.dart';
import '../../repositories/historico/i_historico_repository.dart';

class RegisterAttendanceParams {
  final String alunoId;
  final String turmaId;
  final String aulaId;
  final DateTime data;
  final String? tecnicaAprendida;

  RegisterAttendanceParams({
    required this.alunoId,
    required this.turmaId,
    required this.aulaId,
    required this.data,
    this.tecnicaAprendida,
  });
}

class RegisterAttendanceException implements Exception {
  final String message;
  RegisterAttendanceException(this.message);

  @override
  String toString() => 'RegisterAttendanceException: $message';
}

abstract class RegisterAttendanceUsecase {
  AsyncResult<AulaRealizada> call(RegisterAttendanceParams params);
}

/// Use Case: Registrar Presença (Regra crítica: incrementa contador +1)
class RegisterAttendanceUseCaseImpl implements RegisterAttendanceUsecase {
  final AlunoRepository _alunoRepository;
  final AulaRepository _aulaRepository;
  final HistoricoPresencaRepository _historicoRepository;

  RegisterAttendanceUseCaseImpl(
    this._alunoRepository,
    this._aulaRepository,
    this._historicoRepository,
  );

  @override
  AsyncResult<AulaRealizada> call(RegisterAttendanceParams params) async {
    try {
      // 1. Validações
      final alunoResult = await _alunoRepository.getById(params.alunoId);
      final aluno = alunoResult.fold(
        (a) => a,
        (e) => throw RegisterAttendanceException('Erro ao buscar aluno: $e'),
      );

      if (!aluno.turmasIds.contains(params.turmaId)) {
        return Failure(
          RegisterAttendanceException('Aluno não pertence a esta turma'),
        );
      }

      // 2. Verificar presença duplicada
      final duplicadaResult = await _aulaRepository.verificarPresencaDuplicada(
        params.alunoId,
        params.turmaId,
        params.data,
      );
      final duplicada = duplicadaResult.fold(
        (d) => d,
        (e) =>
            throw RegisterAttendanceException('Erro ao verificar presença: $e'),
      );

      if (duplicada) {
        return Failure(
          RegisterAttendanceException(
            'Presença já registrada para este aluno nesta aula',
          ),
        );
      }

      // 3. Buscar aula e adicionar aluno na lista de presentes
      final aulaResult = await _aulaRepository.getById(params.aulaId);
      final aula = aulaResult.fold(
        (a) => a,
        (e) => throw RegisterAttendanceException('Erro ao buscar aula: $e'),
      );

      final aulaAtualizada = aula.registrarPresenca(params.alunoId);
      await _aulaRepository
          .update(aulaAtualizada)
          .fold(
            (_) => null,
            (e) =>
                throw RegisterAttendanceException('Erro ao atualizar aula: $e'),
          );

      // 4. INCREMENTAR aulas_realizadas_nesta_faixa +1 (REGRA CRÍTICA)
      final novoStatus = aluno.statusGraduacao.incrementarAula();
      final alunoAtualizado = aluno.copyWith(statusGraduacao: novoStatus);
      await _alunoRepository
          .update(alunoAtualizado)
          .fold(
            (_) => null,
            (e) => throw RegisterAttendanceException(
              'Erro ao atualizar aluno: $e',
            ),
          );

      // 5. Criar registro no histórico de presença
      final historicoPresenca = HistoricoPresenca(
        id: '${params.alunoId}_${params.data.toIso8601String()}',
        data: params.data,
        turmaId: params.turmaId,
        tecnicaAprendida: params.tecnicaAprendida,
      );
      await _historicoRepository
          .create(params.alunoId, historicoPresenca)
          .fold(
            (_) => null,
            (e) => throw RegisterAttendanceException(
              'Erro ao criar histórico de presença: $e',
            ),
          );

      return Success(aulaAtualizada);
    } on RegisterAttendanceException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        RegisterAttendanceException(
          'Erro inesperado ao registrar presença: $e',
        ),
      );
    }
  }
}
