class UnauthenticatedException implements Exception
{
  final String message;
  UnauthenticatedException({this.message="Usuário não autenticado"});
}