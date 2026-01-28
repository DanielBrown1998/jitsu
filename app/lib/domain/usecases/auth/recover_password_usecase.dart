import '../../repositories/auth/i_auth_repository.dart';

abstract class RecoverPasswordUseCase {
  Future<void> call(String email);
}

class RecoverPasswordUseCaseImpl implements RecoverPasswordUseCase {
  final IAuthRepository _repository;

  RecoverPasswordUseCaseImpl(this._repository);

  @override
  Future<void> call(String email) async {
    if (!_isValidEmail(email)) {
      throw ArgumentError('Formato de email inválido');
    }

    await _repository.recoverPassword(email);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
