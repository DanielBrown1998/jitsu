import '../../entities/turma.dart';
import '../../repositories/turma/i_turma_repository.dart';

class GetTurmasParams {
  final String? alunoId;
  final List<String>? turmaIds;

  GetTurmasParams({this.alunoId, this.turmaIds});
}

abstract class GetTurmasUsecase {
  Future<List<Turma>> call(GetTurmasParams? params);
}

/// Use Case: Listar Turmas
class GetTurmasUseCaseImpl implements GetTurmasUsecase {
  final ITurmaRepository _repository;

  GetTurmasUseCaseImpl(this._repository);

  @override
  Future<List<Turma>> call(GetTurmasParams? params) async {
    if (params?.turmaIds != null && params!.turmaIds!.isNotEmpty) {
      // Filtrar por IDs específicos (turmas do aluno)
      return await _repository.getByIds(params.turmaIds!);
    }

    // Retornar todas as turmas
    return await _repository.getAll();
  }
}
