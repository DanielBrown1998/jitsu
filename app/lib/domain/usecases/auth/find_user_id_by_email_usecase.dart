import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class FindUserIdByEmailException implements Exception {
  final String message;

  FindUserIdByEmailException(this.message);

  @override
  String toString() => 'FindUserIdByEmailException: $message';
}

abstract class FindUserIdByEmailUsecase {
  AsyncResult<String> call(String email);
}

class FindUserIdByEmailUseCaseImpl implements FindUserIdByEmailUsecase {
  final AuthRepository _repository;

  FindUserIdByEmailUseCaseImpl(this._repository);

  @override
  AsyncResult<String> call(String email) async {
    if (email.trim().isEmpty) {
      return Failure(FindUserIdByEmailException('email nao pode ser vazio'));
    }

    return await _repository
        .findUserIdByEmail(email.trim())
        .fold(
          (userId) => Success(userId),
          (error) => Failure(
            FindUserIdByEmailException(
              'Erro ao localizar usuario por email: ${error.toString()}',
            ),
          ),
        );
  }
}
