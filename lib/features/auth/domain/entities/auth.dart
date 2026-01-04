class Auth {
  String? _email;
  String? _password;

  Auth({String? email, String? password})
  {
    setEmail = email;
    setPassword = password;
  }

  set setEmail(String? value)  => _email = value;
  set setPassword(String? value)  => _password = value;

  String? get getEmail => _email;
  String? get getPassword => _password;
}