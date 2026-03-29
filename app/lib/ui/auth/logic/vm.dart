import 'dart:async';
import 'package:app/domain/entities/aluno.dart';
import 'package:app/domain/entities/professor.dart';
import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:app/domain/usecases/usecases.dart';
import 'package:app/ui/auth/logic/command.dart';
import 'package:app/ui/auth/logic/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:result_dart/result_dart.dart';

class AuthVm extends ChangeNotifier {
  static const String _logPrefix = '[AuthVm]';

  final WatchAuthStateUseCase watchAuthStateUseCase;
  final LoginWithEmailUseCase loginWithEmailUseCase;
  final LogoutUsecase logoutUseCase;
  final RecoverPasswordUseCase recoverPasswordUseCase;
  final RegisterUseCase registerUseCase;
  final GetUserRoleUsecase getUserRoleUsecase;
  final CreateStudentProfileUsecase createStudentProfileUsecase;
  final GetAlunoProfileUsecase getAlunoProfileUsecase;
  final GetProfessorProfileUsecase getProfessorProfileUsecase;

  final AuthState state = AuthState(
    user: null,
    isLoading: false,
    error: null,
    isLoggedIn: false,
    role: UserRole.student,
    aluno: null,
    professor: null,
  );

  StreamSubscription? _authStateSubscription;
  Stream<Result<User>> get _stream => watchAuthStateUseCase();

  late final LoginCommand loginCommand;
  late final LogoutCommand logoutCommand;
  late final RecoverPasswordCommand recoverPasswordCommand;
  late final RegisterCommand registerCommand;

  void _log(String message) {
    debugPrint('$_logPrefix $message');
  }

  AuthVm({
    required this.watchAuthStateUseCase,
    required this.loginWithEmailUseCase,
    required this.logoutUseCase,
    required this.recoverPasswordUseCase,
    required this.registerUseCase,
    required this.getUserRoleUsecase,
    required this.createStudentProfileUsecase,
    required this.getAlunoProfileUsecase,
    required this.getProfessorProfileUsecase,
  }) {
    _log('Inicializando ViewModel');
    _watchAuthState();
    loginCommand = LoginCommand(_loginWithEmail);
    logoutCommand = LogoutCommand(_logout);
    recoverPasswordCommand = RecoverPasswordCommand(_recoverPassword);
    registerCommand = RegisterCommand(_register);
    _log('Comandos de autenticacao inicializados');
  }

  @override
  void dispose() {
    _log('Dispose chamado. Cancelando assinatura de auth state.');
    _authStateSubscription?.cancel();
    super.dispose();
  }

  void _watchAuthState() {
    _log('Iniciando escuta de auth state');
    state.emit(isLoading: true);
    notifyListeners();

    _authStateSubscription = _stream.listen((result) async {
      User? user;
      Object? failure;
      result.fold((success) => user = success, (error) => failure = error);

      if (user != null) {
        final currentUser = user!;
        _log('Usuario autenticado no stream. uid=${currentUser.uid}');

        final roleResult = await getUserRoleUsecase(currentUser.uid);
        final role = roleResult.fold(
          (success) => _toUiRole(success),
          (_) => UserRole.student,
        );
        _log('Papel do usuario resolvido: $role');
        final professor = await _loadProfessor(currentUser.uid);
        final aluno = await _loadAluno(currentUser.uid);
        _log(
          'Perfis carregados. aluno=${aluno != null}, professor=${professor != null}',
        );

        state.emit(
          user: currentUser,
          isLoading: false,
          clearError: true,
          isLoggedIn: true,
          role: role,
          aluno: aluno,
          professor: professor,
        );
        notifyListeners();
        _log('Estado atualizado para autenticado.');
        return;
      }

      _log('Usuario nao autenticado no stream. erro=$failure');

      state.emit(
        user: null,
        isLoading: false,
        error: failure?.toString() ?? 'Usuario nao autenticado.',
        isLoggedIn: false,
        role: UserRole.student,
        clearAluno: true,
        clearProfessor: true,
      );
      notifyListeners();
      _log('Estado atualizado para deslogado.');
    });
  }

  void refresh() {
    _log('Refresh solicitado. Reiniciando escuta de auth state.');
    _authStateSubscription?.cancel();
    _watchAuthState();
  }

  Future<void> _recoverPassword(RecoverPasswordInput input) async {
    _log('Recuperacao de senha iniciada para email=${input.email}');
    state.emit(isLoading: true);
    notifyListeners();

    await recoverPasswordUseCase(input.email).fold(
      (_) {
        state.emit(isLoading: false, clearError: true);
        notifyListeners();
        _log('Recuperacao de senha concluida com sucesso.');
      },
      (error) {
        state.emit(isLoading: false, error: error.toString());
        notifyListeners();
        _log('Falha na recuperacao de senha: $error');
      },
    );
  }

  void resetError() {
    _log('Reset de erro solicitado.');
    state.emit(clearError: true);
    notifyListeners();
  }

  Future<void> _register(RegisterInput input) async {
    _log('Registro iniciado para email=${input.email}');
    state.emit(isLoading: true);
    notifyListeners();

    final result = await registerUseCase(input.email, input.password);
    await result.fold(
      (user) async {
        _log('Usuario registrado com sucesso. uid=${user.uid}');
        final createProfileResult = await createStudentProfileUsecase(user);
        final createError = createProfileResult.fold(
          (_) => null,
          (error) => error.toString(),
        );
        _log(
          createError == null
              ? 'Perfil de aluno criado com sucesso.'
              : 'Falha ao criar perfil de aluno: $createError',
        );

        await logoutUseCase(user.uid);
        _log('Logout pos-registro executado para uid=${user.uid}');

        state.emit(
          user: null,
          isLoading: false,
          error: createError,
          isLoggedIn: false,
          role: UserRole.student,
          clearAluno: true,
          clearProfessor: true,
        );
        notifyListeners();
        _log('Estado atualizado apos registro (usuario deslogado).');
      },
      (error) {
        state.emit(
          isLoading: false,
          error: error.toString(),
          isLoggedIn: false,
        );
        notifyListeners();
        _log('Falha no registro: $error');
      },
    );
  }

  Future<void> _loginWithEmail(LoginInput input) async {
    _log('Login iniciado para email=${input.email}');
    state.emit(isLoading: true);
    notifyListeners();

    final result = await loginWithEmailUseCase(
      LoginParams(email: input.email, password: input.password),
    );

    LoginResult? loginResult;
    Object? failure;
    result.fold((success) => loginResult = success, (error) => failure = error);

    if (loginResult == null) {
      _log('Falha no login: $failure');
      state.emit(
        user: null,
        isLoading: false,
        error: failure.toString(),
        isLoggedIn: false,
        clearAluno: true,
        clearProfessor: true,
      );
      notifyListeners();
      return;
    }

    _log('Login concluido com sucesso. uid=${loginResult!.user.uid}');
    final roleResult = await getUserRoleUsecase(loginResult!.user.uid);
    _log('Resultado da consulta de papel: $roleResult');
    final userRole = roleResult.fold(
      (success) => _toUiRole(success),
      (_) => UserRole.student,
    );
    final professor = await _loadProfessor(loginResult!.user.uid);
    final aluno = await _loadAluno(loginResult!.user.uid);
    _log(
      'Perfis apos login. role=$userRole, aluno=${aluno != null}, professor=${professor != null}',
    );

    state.emit(
      user: loginResult!.user,
      isLoading: false,
      clearError: true,
      isLoggedIn: true,
      role: userRole,
      professor: professor,
      aluno: aluno,
    );
    notifyListeners();
    _log('Estado atualizado para autenticado via login.');
  }

  Future<void> _logout(LogoutInput input) async {
    _log('Logout iniciado. uid=${state.user?.uid ?? 'nulo'}');
    await logoutUseCase(state.user?.uid ?? '').fold(
      (_) {
        state.emit(
          user: null,
          isLoading: false,
          clearError: true,
          isLoggedIn: false,
          role: UserRole.student,
          clearAluno: true,
          clearProfessor: true,
        );
        notifyListeners();
        _log('Logout concluido com sucesso.');
      },
      (error) {
        state.emit(error: error.toString());
        notifyListeners();
        _log('Falha no logout: $error');
      },
    );
  }

  UserRole _toUiRole(AuthUserRole role) {
    _log('Convertendo papel de dominio para UI: $role');
    return switch (role) {
      AuthUserRole.student => UserRole.student,
      AuthUserRole.admin => UserRole.admin,
      AuthUserRole.professor => UserRole.professor,
    };
  }

  Future<Aluno?> _loadAluno(String userId) async {
    _log('Carregando perfil de aluno para uid=$userId');
    final result = await getAlunoProfileUsecase(userId);
    return result.fold(
      (success) {
        _log('Perfil de aluno carregado com sucesso para uid=$userId');
        return success.aluno;
      },
      (error) {
        _log('Falha ao carregar perfil de aluno para uid=$userId: $error');
        return null;
      },
    );
  }

  Future<Professor?> _loadProfessor(String userId) async {
    _log('Carregando perfil de professor para uid=$userId');
    final result = await getProfessorProfileUsecase(userId);
    return result.fold(
      (success) {
        _log('Perfil de professor carregado com sucesso para uid=$userId');
        return success;
      },
      (error) {
        _log('Falha ao carregar perfil de professor para uid=$userId: $error');
        return null;
      },
    );
  }
}
