class UserNotAllowedException implements Exception {
  final String message;
  UserNotAllowedException([this.message = "Usuário não autorizado a acessar o sistema."]);
}