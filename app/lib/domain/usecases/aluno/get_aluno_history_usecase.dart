import 'package:result_dart/result_dart.dart';

import '../../entities/historico_graduacao.dart';
import '../../repositories/aluno/i_aluno_repository.dart';

class GetAlunoHistoryException implements Exception {
  final String message;
  GetAlunoHistoryException(this.message);

  @override
  String toString() => 'GetAlunoHistoryException: $message';
}

abstract class GetAlunoHistoryUsecase {
  AsyncResult<List<HistoricoGraduacao>> call(String alunoId);
}

/// Use Case: Ver Histórico de Graduações do Aluno
class GetAlunoHistoryUseCaseImpl implements GetAlunoHistoryUsecase {
  final AlunoRepository _repository;

  GetAlunoHistoryUseCaseImpl(this._repository);

  @override
  AsyncResult<List<HistoricoGraduacao>> call(String alunoId) async {
    if (alunoId.isEmpty) {
      return Failure(GetAlunoHistoryException('alunoId não pode ser vazio'));
    }

    return await _repository.getHistorico(alunoId).fold(
      (historico) {
        // Ordenar por data DESC (mais recente primeiro)
        historico.sort((a, b) => b.data.compareTo(a.data));
        return Success(historico);
      },
      (error) => Failure(
        GetAlunoHistoryException(
          'Erro ao buscar histórico: ${error.toString()}',
        ),
      ),
    );
  }
}
