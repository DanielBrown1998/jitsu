import 'package:app/infra/source/auth/auth_source.dart';
import 'package:result_dart/result_dart.dart';

class LoginResult {
  final String userId;
  final String token;
  final String nome;

  LoginResult({required this.userId, required this.token, required this.nome});
}

abstract class IAuthWorkflow {
  AsyncResult<LoginResult> login(String email, String password);
  AsyncResult<Unit> logout(String userId);
  AsyncResult<Unit> recoverPassword(String email);
}

abstract class AuthRepository implements IAuthWorkflow {}

class AuthRepositoryImpl implements AuthRepository {
  final AuthSource source;

  AuthRepositoryImpl({required this.source});

  @override
  AsyncResult<LoginResult> login(String email, String password) async =>
      await source.login(email, password);

  @override
  AsyncResult<Unit> logout(String userId) async => await source.logout(userId);

  @override
  AsyncResult<Unit> recoverPassword(String email) async =>
      await source.recoverPassword(email);
}
