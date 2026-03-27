import 'package:result_dart/result_dart.dart';

import '../../repositories/auth/i_auth_repository.dart';

class RecoverPasswordException implements Exception {
  final String message;
  RecoverPasswordException(this.message);

  @override
  String toString() => 'RecoverPasswordException: $message';
}

abstract class RecoverPasswordUseCase {
  AsyncResult<Unit> call(String email);
}

class RecoverPasswordUseCaseImpl implements RecoverPasswordUseCase {
  final AuthRepository _repository;

  RecoverPasswordUseCaseImpl(this._repository);

  @override
  AsyncResult<Unit> call(String email) async {
    if (!_isValidEmail(email)) {
      return Failure(RecoverPasswordException('Formato de email inválido'));
    }

    return await _repository
        .recoverPassword(email)
        .fold(
          (_) => const Success(unit),
          (error) => Failure(
            RecoverPasswordException(
              'Erro ao recuperar senha: ${error.toString()}',
            ),
          ),
        );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
