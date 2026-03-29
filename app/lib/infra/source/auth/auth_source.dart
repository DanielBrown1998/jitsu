import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:app/core/storage/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

import '../../../core/auth/firebase_auth.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/firebase/instance.dart';

abstract class AuthSource implements IAuthWorkflow {}

class AuthSourceImpl implements AuthSource {
  final AppStorage storage;

  AuthSourceImpl({required this.storage});

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      FirebaseInstance.firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _alunosCollection =>
      FirebaseInstance.firestore.collection('alunos');

  @override
  AsyncResult<bool> isLoggedIn() async {
    try {
      final user = FirebaseAuthService.currentUser;
      return Success(user != null);
    } catch (e) {
      return Failure(
        AuthException('Erro ao verificar status de login: ${e.toString()}'),
      );
    }
  }

  @override
  Stream<Result<User>> authStateChanges() {
    return FirebaseAuthService.authState.asyncMap(_mapUser);
  }

  Future<Result<User>> _mapUser(User? user) async {
    if (user != null) {
      try {
        await _refreshAndPersistSession(user);
        return Success(user);
      } catch (e) {
        await _clearPersistedSession();
        try {
          await FirebaseAuthService.signOut();
        } catch (_) {}
        return Failure(
          AuthException('Sessao invalida. Realize login novamente.'),
        );
      }
    } else {
      await _clearPersistedSession();
      return Failure(AuthException('Nenhum usuário autenticado.'));
    }
  }

  @override
  AsyncResult<LoginResult> login(String email, String password) async {
    try {
      final user = await FirebaseAuthService.signInWithEmail(
        email: email,
        password: password,
      );

      final token = await _refreshAndPersistSession(user);
      return Success(
        LoginResult(
          user: user,
          userId: user.uid,
          token: token,
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
      await _clearPersistedSession();
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

  @override
  AsyncResult<User> register(String email, String password) async {
    try {
      final user = await FirebaseAuthService.registerWithEmail(
        email: email,
        password: password,
      );
      return Success(user);
    } on AuthException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(AuthException('Erro no registro: ${e.toString()}'));
    }
  }

  @override
  AsyncResult<AuthUserRole> getUserRole(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      final roleRaw = userDoc.data()?['role']?.toString().trim().toLowerCase();

      final role = switch (roleRaw) {
        'admin' => AuthUserRole.admin,
        'professor' => AuthUserRole.professor,
        _ => AuthUserRole.student,
      };

      return Success(role);
    } on FirebaseException catch (e) {
      return Failure(
        AuthException('Erro ao buscar role de usuario: ${e.message ?? e.code}'),
      );
    } catch (e) {
      return Failure(
        AuthException('Erro ao buscar role de usuario: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<String> findUserIdByEmail(String email) async {
    try {
      final query = await _usersCollection
          .where('email', isEqualTo: email.toLowerCase())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return Failure(
          AuthException('Usuario nao encontrado para o email informado.'),
        );
      }

      return Success(query.docs.first.id);
    } on FirebaseException catch (e) {
      return Failure(
        AuthException(
          'Erro ao buscar usuario por email: ${e.message ?? e.code}',
        ),
      );
    } catch (e) {
      return Failure(
        AuthException('Erro ao buscar usuario por email: ${e.toString()}'),
      );
    }
  }

  @override
  AsyncResult<Unit> createStudentProfile(User user) async {
    try {
      await _usersCollection.doc(user.uid).set({
        'userId': user.uid,
        'email': (user.email ?? '').toLowerCase(),
        'nome': user.displayName ?? user.email ?? 'Aluno',
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      final alunoDoc = await _alunosCollection.doc(user.uid).get();
      if (!alunoDoc.exists) {
        await _alunosCollection.doc(user.uid).set({
          'id': user.uid,
          'nome': user.displayName ?? user.email ?? 'Aluno',
          'email': (user.email ?? '').toLowerCase(),
          'telefone': '',
          'dataNascimento': '',
          'turmasIds': <String>[],
          'statusGraduacao': {
            'faixaAtual': 'Branca',
            'graus': 0,
            'dataUltimaGraduacao': DateTime.now().millisecondsSinceEpoch,
            'aulasRealizadasNestaFaixa': 0,
          },
          'isAtivo': true,
        }, SetOptions(merge: true));
      }

      return const Success(unit);
    } on FirebaseException catch (e) {
      return Failure(
        AuthException('Erro ao criar perfil de aluno: ${e.message ?? e.code}'),
      );
    } catch (e) {
      return Failure(
        AuthException('Erro ao criar perfil de aluno: ${e.toString()}'),
      );
    }
  }

  Future<String> _refreshAndPersistSession(User user) async {
    final token = await user.getIdToken(true);
    if (token == null || token.isEmpty) {
      throw AuthException('Token de sessao invalido.');
    }

    await storage.write(key: StorageKeys.authUserId, value: user.uid);
    await storage.write(key: StorageKeys.authSessionToken, value: token);
    return token;
  }

  Future<void> _clearPersistedSession() async {
    await storage.delete(key: StorageKeys.authUserId);
    await storage.delete(key: StorageKeys.authSessionToken);
  }
}
