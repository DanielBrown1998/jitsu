import '../../entities/historico_graduacao.dart';
import '../../repositories/aluno/i_aluno_repository.dart';

abstract class GetAlunoHistoryUsecase {
  Future<List<HistoricoGraduacao>> call(String alunoId);
}

/// Use Case: Ver Histórico de Graduações do Aluno
class GetAlunoHistoryUseCaseImpl implements GetAlunoHistoryUsecase {
  final IAlunoRepository _repository;

  GetAlunoHistoryUseCaseImpl(this._repository);

  @override
  Future<List<HistoricoGraduacao>> call(String alunoId) async {
    if (alunoId.isEmpty) {
      throw ArgumentError('alunoId não pode ser vazio');
    }

    final historico = await _repository.getHistorico(alunoId);

    // Ordenar por data DESC (mais recente primeiro)
    historico.sort((a, b) => b.data.compareTo(a.data));

    return historico;
  }
}
