import 'package:firebase_auth/firebase_auth.dart';

import '../error/exceptions.dart';
import '../firebase/instance.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuth get _auth => FirebaseInstance.auth;

  static User? get currentUser => _auth.currentUser;

  static Future<User> registerWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(
        'Erro ao registrar com email e senha: ${e.toString()}',
      );
    }
  }

  static Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user!;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Erro ao logar com email e senha: ${e.toString()}');
    }
  }

  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthException('Erro ao deslogar: ${e.toString()}');
    }
  }

  static String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email inválido.';
      case 'user-disabled':
        return 'Conta desativada.';
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Email já está em uso.';
      case 'operation-not-allowed':
        return 'Operação não permitida.';
      case 'weak-password':
        return 'Senha fraca. Use 6 caracteres ou mais.';
      default:
        return 'Erro de autenticação: ${e.message ?? e.code}';
    }
  }
}
