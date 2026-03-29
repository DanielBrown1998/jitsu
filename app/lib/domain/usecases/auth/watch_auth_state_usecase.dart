import 'package:app/domain/repositories/auth/i_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

abstract class WatchAuthStateUseCase {
  Stream<Result<User>> call();
}

class WatchAuthStateUsecaseException implements Exception {
  final String message;
  WatchAuthStateUsecaseException(this.message);

  @override
  String toString() => 'WatchAuthStateUsecaseException: $message';
}

class WatchAuthStateUseCaseImpl implements WatchAuthStateUseCase {
  final AuthRepository _repository;

  WatchAuthStateUseCaseImpl(this._repository);

  @override
  Stream<Result<User>> call() {
    return _repository.authStateChanges().map(_userHandler);
  }

  Result<User> _userHandler(Result<User> result) {
    try {
      if (result.isSuccess()) {
        return Success(
          result.fold(
            (user) => user,
            (error) => throw WatchAuthStateUsecaseException(error.toString()),
          ),
        );
      } else {
        return Failure(WatchAuthStateUsecaseException('No user logged in'));
      }
    } on WatchAuthStateUsecaseException catch (e) {
      return Failure(WatchAuthStateUsecaseException(e.toString()));
    } catch (e) {
      return Failure(WatchAuthStateUsecaseException('Unexpected error: $e'));
    }
  }
}
