// TODO: State model for auth screen.
import 'package:app/domain/entities/aluno.dart';
import 'package:app/domain/entities/professor.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum UserRole { student, admin, professor }

class AuthState {
  User? user;
  bool isLoading;
  String? error;
  bool isLoggedIn;
  UserRole role;
  Aluno? aluno;
  Professor? professor;

  AuthState({
    required this.user,
    required this.isLoading,
    required this.error,
    required this.isLoggedIn,
    required this.role,
    required this.aluno,
    required this.professor,
  });

  AuthState emit({
    User? user,
    bool? isLoading,
    String? error,
    bool? isLoggedIn,
    UserRole? role,
    Aluno? aluno,
    Professor? professor,
    bool clearError = false,
    bool clearAluno = false,
    bool clearProfessor = false,
  }) {
    this.user = user ?? this.user;
    this.isLoading = isLoading ?? this.isLoading;
    this.error = clearError ? null : error ?? this.error;
    this.isLoggedIn = isLoggedIn ?? this.isLoggedIn;
    this.role = role ?? this.role;
    this.aluno = clearAluno ? null : aluno ?? this.aluno;
    this.professor = clearProfessor ? null : professor ?? this.professor;
    return this;
  }
}
