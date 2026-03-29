import 'package:app/domain/entities/professor.dart';
import 'package:app/domain/repositories/professor/i_professor_repository.dart';
import 'package:result_dart/result_dart.dart';

class GetProfessorProfileException implements Exception {
  final String message;

  GetProfessorProfileException(this.message);

  @override
  String toString() => 'GetProfessorProfileException: $message';
}

abstract class GetProfessorProfileUsecase {
  AsyncResult<Professor> call(String professorId);
}

class GetProfessorProfileUseCaseImpl implements GetProfessorProfileUsecase {
  final ProfessorRepository _repository;

  GetProfessorProfileUseCaseImpl(this._repository);

  @override
  AsyncResult<Professor> call(String professorId) async {
    if (professorId.isEmpty) {
      return Failure(
        GetProfessorProfileException('professorId nao pode ser vazio'),
      );
    }

    return await _repository
        .getById(professorId)
        .fold(
          (professor) => Success(professor),
          (error) => Failure(
            GetProfessorProfileException(
              'Erro ao buscar perfil do professor: ${error.toString()}',
            ),
          ),
        );
  }
}
