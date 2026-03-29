import 'package:app/infra/source/auth/auth_source.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class LoginResult {
  final User user;
  final String userId;
  final String token;
  final String nome;

  LoginResult({
    required this.user,
    required this.userId,
    required this.token,
    required this.nome,
  });
}

enum AuthUserRole { student, admin, professor }

abstract class IAuthWorkflow {
  AsyncResult<LoginResult> login(String email, String password);
  AsyncResult<Unit> logout(String userId);
  AsyncResult<Unit> recoverPassword(String email);
  AsyncResult<bool> isLoggedIn();
  Stream<Result<User>> authStateChanges();
  AsyncResult<User> register(String email, String password);
  AsyncResult<AuthUserRole> getUserRole(String userId);
  AsyncResult<String> findUserIdByEmail(String email);
  AsyncResult<Unit> createStudentProfile(User user);
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

  @override
  AsyncResult<bool> isLoggedIn() async => await source.isLoggedIn();

  @override
  Stream<Result<User>> authStateChanges() => source.authStateChanges();

  @override
  AsyncResult<User> register(String email, String password) async =>
      await source.register(email, password);

  @override
  AsyncResult<AuthUserRole> getUserRole(String userId) async =>
      await source.getUserRole(userId);

  @override
  AsyncResult<String> findUserIdByEmail(String email) async =>
      await source.findUserIdByEmail(email);

  @override
  AsyncResult<Unit> createStudentProfile(User user) async =>
      await source.createStudentProfile(user);
}
