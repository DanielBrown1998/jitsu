import 'package:app/domain/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

abstract class RegisterUseCase {
  AsyncResult<User> call(String email, String password);
}

class RegisterUseCaseException implements Exception {
  final String message;
  RegisterUseCaseException(this.message);
  @override
  String toString() => 'RegisterException: $message';
}

class RegisterUseCaseImpl implements RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCaseImpl(this.repository);
  @override
  AsyncResult<User> call(String email, String password) async {
    try {
      final result = await repository.register(email, password);
      return result.fold(
        (success) => Success(success),
        (failure) => throw RegisterUseCaseException(failure.toString()),
      );
    } catch (e) {
      return Failure(
        RegisterUseCaseException('Erro ao registrar: ${e.toString()}'),
      );
    }
  }
}
