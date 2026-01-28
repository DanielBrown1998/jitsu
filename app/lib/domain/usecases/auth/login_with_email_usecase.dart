import '../../repositories/auth/i_auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

abstract class LoginWithEmailUseCase {
  Future<LoginResult> call(LoginParams params);
}

class LoginWithEmailUseCaseImpl implements LoginWithEmailUseCase {
  final IAuthRepository _repository;

  LoginWithEmailUseCaseImpl(this._repository);

  @override
  Future<LoginResult> call(LoginParams params) async {
    // Validação de email
    if (!_isValidEmail(params.email)) {
      throw ArgumentError('Formato de email inválido');
    }

    if (params.password.length < 6) {
      throw ArgumentError('Senha deve ter no mínimo 6 caracteres');
    }

    return await _repository.login(params.email, params.password);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
