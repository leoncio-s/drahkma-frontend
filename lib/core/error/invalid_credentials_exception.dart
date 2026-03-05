class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException([this.message = "Email ou senha inválidos."]);
}