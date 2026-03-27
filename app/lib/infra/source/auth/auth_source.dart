import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import '../../../core/auth/firebase_auth.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/firebase/instance.dart';

abstract class AuthSource implements IAuthWorkflow {}

class AuthSourceImpl implements AuthSource {
  @override
  AsyncResult<LoginResult> login(String email, String password) async {
    try {
      final user = await FirebaseAuthService.signInWithEmail(
        email: email,
        password: password,
      );

      final token = await user.getIdToken();
      return Success(
        LoginResult(
          userId: user.uid,
          token: token ?? '',
          nome: user.displayName ?? user.email ?? user.uid,
        ),
      );
    } on AuthException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthException('Erro no login: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Unit> logout(String userId) async {
    try {
      await FirebaseAuthService.signOut();
      return const Success(unit);
    } on AuthException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthException('Erro ao deslogar: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<Unit> recoverPassword(String email) async {
    try {
      await FirebaseInstance.auth.sendPasswordResetEmail(email: email);
      return const Success(unit);
    } on FirebaseAuthException catch (e) {
      return Failure(AuthException(e.message ?? 'Erro ao recuperar senha.'));
    } catch (e) {
      return Failure(AuthException('Erro ao recuperar senha: ${e.toString()}'));
    }
  }
}
