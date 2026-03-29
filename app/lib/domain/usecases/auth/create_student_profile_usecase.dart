import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class CreateStudentProfileException implements Exception {
  final String message;

  CreateStudentProfileException(this.message);

  @override
  String toString() => 'CreateStudentProfileException: $message';
}

abstract class CreateStudentProfileUsecase {
  AsyncResult<Unit> call(User user);
}

class CreateStudentProfileUseCaseImpl implements CreateStudentProfileUsecase {
  final AuthRepository _repository;

  CreateStudentProfileUseCaseImpl(this._repository);

  @override
  AsyncResult<Unit> call(User user) async {
    return await _repository
        .createStudentProfile(user)
        .fold(
          (_) => const Success(unit),
          (error) => Failure(
            CreateStudentProfileException(
              'Erro ao criar perfil padrao de aluno: ${error.toString()}',
            ),
          ),
        );
  }
}
