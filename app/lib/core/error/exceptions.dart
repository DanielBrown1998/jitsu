class AppExceptions implements Exception {}

class AuthException extends AppExceptions {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class DatabaseException extends AppExceptions {
  final String message;

  DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}
