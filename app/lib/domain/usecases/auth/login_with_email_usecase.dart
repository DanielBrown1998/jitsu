import 'package:result_dart/result_dart.dart';

import '../../repositories/auth/i_auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class LoginException implements Exception {
  final String message;
  LoginException(this.message);

  @override
  String toString() => 'LoginException: $message';
}

abstract class LoginWithEmailUseCase {
  AsyncResult<LoginResult> call(LoginParams params);
}

class LoginWithEmailUseCaseImpl implements LoginWithEmailUseCase {
  final AuthRepository _repository;

  LoginWithEmailUseCaseImpl(this._repository);

  @override
  AsyncResult<LoginResult> call(LoginParams params) async {
    // Validação de email
    if (!_isValidEmail(params.email)) {
      return Failure(LoginException('Formato de email inválido'));
    }

    if (params.password.length < 6) {
      return Failure(LoginException('Senha deve ter no mínimo 6 caracteres'));
    }

    return await _repository
        .login(params.email, params.password)
        .fold(
          (loginResult) => Success(loginResult),
          (error) => Failure(
            LoginException('Erro ao fazer login: ${error.toString()}'),
          ),
        );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
