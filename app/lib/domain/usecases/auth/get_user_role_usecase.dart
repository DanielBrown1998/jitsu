import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:result_dart/result_dart.dart';

class GetUserRoleException implements Exception {
  final String message;

  GetUserRoleException(this.message);

  @override
  String toString() => 'GetUserRoleException: $message';
}

abstract class GetUserRoleUsecase {
  AsyncResult<AuthUserRole> call(String userId);
}

class GetUserRoleUseCaseImpl implements GetUserRoleUsecase {
  final AuthRepository _repository;

  GetUserRoleUseCaseImpl(this._repository);

  @override
  AsyncResult<AuthUserRole> call(String userId) async {
    if (userId.isEmpty) {
      return Failure(GetUserRoleException('userId nao pode ser vazio'));
    }

    return await _repository
        .getUserRole(userId)
        .fold(
          (role) => Success(role),
          (error) => Failure(
            GetUserRoleException(
              'Erro ao obter role do usuario: ${error.toString()}',
            ),
          ),
        );
  }
}
