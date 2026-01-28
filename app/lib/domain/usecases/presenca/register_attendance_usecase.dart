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

abstract class RegisterAttendanceUsecase {
  Future<AulaRealizada> call(RegisterAttendanceParams params);
}

/// Use Case: Registrar Presença (Regra crítica: incrementa contador +1)
class RegisterAttendanceUseCaseImpl implements RegisterAttendanceUsecase {
  final IAlunoRepository _alunoRepository;
  final IAulaRepository _aulaRepository;
  final IHistoricoPresencaRepository _historicoRepository;

  RegisterAttendanceUseCaseImpl(
    this._alunoRepository,
    this._aulaRepository,
    this._historicoRepository,
  );

  @override
  Future<AulaRealizada> call(RegisterAttendanceParams params) async {
    // 1. Validações
    final aluno = await _alunoRepository.getById(params.alunoId);
    if (aluno == null) {
      throw Exception('Aluno não encontrado');
    }

    if (!aluno.turmasIds.contains(params.turmaId)) {
      throw Exception('Aluno não pertence a esta turma');
    }

    // 2. Verificar presença duplicada
    final duplicada = await _aulaRepository.verificarPresencaDuplicada(
      params.alunoId,
      params.turmaId,
      params.data,
    );
    if (duplicada) {
      throw Exception('Presença já registrada para este aluno nesta aula');
    }

    // 3. Buscar aula e adicionar aluno na lista de presentes
    final aula = await _aulaRepository.getById(params.aulaId);
    if (aula == null) {
      throw Exception('Aula não encontrada');
    }

    final aulaAtualizada = aula.registrarPresenca(params.alunoId);
    await _aulaRepository.update(aulaAtualizada);

    // 4. INCREMENTAR aulas_realizadas_nesta_faixa +1 (REGRA CRÍTICA)
    final novoStatus = aluno.statusGraduacao.incrementarAula();
    final alunoAtualizado = aluno.copyWith(statusGraduacao: novoStatus);
    await _alunoRepository.update(alunoAtualizado);

    // 5. Criar registro no histórico de presença
    final historicoPresenca = HistoricoPresenca(
      id: '${params.alunoId}_${params.data.toIso8601String()}',
      data: params.data,
      turmaId: params.turmaId,
      tecnicaAprendida: params.tecnicaAprendida,
    );
    await _historicoRepository.create(params.alunoId, historicoPresenca);

    return aulaAtualizada;
  }
}
