class Auth {
  final String? email;
  final String? password;

  Auth({this.email, this.password});

  set email(String? value)  => email = value;
  set password(String? value)  => password = value;
}