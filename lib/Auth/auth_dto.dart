import 'package:drahkma/Interfaces/dto_interface.dart';

class AuthDto implements DtoInterface{
  
  // ignore: unused_field
  late String? _email;
  // ignore: unused_field
  late String? _password;

  AuthDto({String? login, String? password}){
    _email = login;
    _password = password;
  }


  static validateEmail(String? value){
    if(value != null && value.length > 4 && value.length <=150 &&  RegExp(r"^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$").hasMatch(value)){
      return value;
    }else{
      return {"error": "Email inválido ou incorreto, verifique"};
    }
  }

  static validatePassword(String? value){
    if(value != null && RegExp(r'"/^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,20}$/').hasMatch(value)){
      return value;
    }

    return {"error": "Senha inválido ou incorreto, verifique"};
  }

  // String? get Email => _email;
  // String? get Password => _password;

  set Email(String? value)  => _email = value;
  set Password(String? value)  => _password = value;
  
  @override
  toMap() {
    return {
      "email": _email,
      "password" : _password
    };
  }
}