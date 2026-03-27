import 'package:result_dart/result_dart.dart';

import '../../entities/turma.dart';
import '../../repositories/turma/i_turma_repository.dart';

class GetTurmasParams {
  final String? alunoId;
  final List<String>? turmaIds;

  GetTurmasParams({this.alunoId, this.turmaIds});
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
    if (params?.turmaIds != null && params!.turmaIds!.isNotEmpty) {
      // Filtrar por IDs específicos (turmas do aluno)
      return await _repository
          .getByIds(params.turmaIds!)
          .fold(
            (turmas) => Success(turmas),
            (error) => Failure(
              GetTurmasException('Erro ao buscar turmas: ${error.toString()}'),
            ),
          );
    }

    // Retornar todas as turmas
    return await _repository.getAll().fold(
      (turmas) => Success(turmas),
      (error) => Failure(
        GetTurmasException('Erro ao listar turmas: ${error.toString()}'),
      ),
    );
  }
}
