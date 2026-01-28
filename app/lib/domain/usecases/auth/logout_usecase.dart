import '../../repositories/auth/i_auth_repository.dart';

abstract class LogoutUsecase {
  Future<void> call(String userId);
}

class LogoutUseCaseImpl implements LogoutUsecase {
  final IAuthRepository _repository;

  LogoutUseCaseImpl(this._repository);

  @override
  Future<void> call(String userId) async {
    if (userId.isEmpty) {
      throw ArgumentError('userId não pode ser vazio');
    }

    await _repository.logout(userId);
  }
}
