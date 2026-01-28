class LoginResult {
  final String userId;
  final String token;
  final String nome;

  LoginResult({required this.userId, required this.token, required this.nome});
}

abstract class IAuthRepository {
  Future<LoginResult> login(String email, String password);
  Future<void> logout(String userId);
  Future<void> recoverPassword(String email);
}
