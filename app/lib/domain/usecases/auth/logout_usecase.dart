import 'package:result_dart/result_dart.dart';

import '../../repositories/auth/i_auth_repository.dart';

class LogoutException implements Exception {
  final String message;
  LogoutException(this.message);

  @override
  String toString() => 'LogoutException: $message';
}

abstract class LogoutUsecase {
  AsyncResult<Unit> call(String userId);
}

class LogoutUseCaseImpl implements LogoutUsecase {
  final AuthRepository _repository;

  LogoutUseCaseImpl(this._repository);

  @override
  AsyncResult<Unit> call(String userId) async {
    if (userId.isEmpty) {
      return Failure(LogoutException('userId não pode ser vazio'));
    }

    return await _repository
        .logout(userId)
        .fold(
          (_) => const Success(unit),
          (error) => Failure(
            LogoutException('Erro ao fazer logout: ${error.toString()}'),
          ),
        );
  }
}
