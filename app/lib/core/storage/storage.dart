import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AppStorage {
  Future<void> write({required String key, required String value});
  Future<String?> read({required String key});
  Future<void> delete({required String key});
}

abstract final class StorageKeys {
  static const authUserId = 'auth_user_id';
  static const authSessionToken = 'auth_session_token';
}

class SecureAppStorage implements AppStorage {
  final FlutterSecureStorage _storage;

  SecureAppStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _storage.delete(key: key);
  }
}
