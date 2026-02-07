
import 'package:drahkma/core/mixins/dto_mixin.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';

class AuthModel extends Auth with DTOMixin{

  AuthModel({String? login, String? password}){
    super.setEmail = login;
    super.setPassword = password;
  }


  static dynamic validateEmail(String? value){
    if(value != null && value.length > 4 && value.length <=150 &&  RegExp(r"^([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x22([^\x0d\x22\x5c\x80-\xff]|\x5c[\x00-\x7f])*\x22))*\x40([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d)(\x2e([^\x00-\x20\x22\x28\x29\x2c\x2e\x3a-\x3c\x3e\x40\x5b-\x5d\x7f-\xff]+|\x5b([^\x0d\x5b-\x5d\x80-\xff]|\x5c[\x00-\x7f])*\x5d))*$").hasMatch(value)){
      return value;
    }else{
      return {"error": "Email inválido ou incorreto, verifique"};
    }
  }

  static dynamic validatePassword(String? value){
    if(value != null && RegExp(r'"/^(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[^\w\d\s:])([^\s]){8,20}$/').hasMatch(value)){
      return value;
    }

    return {"error": "Senha inválido ou incorreto, verifique"};
  }
  
  @override
  Map<String, String?>toMap() {
    return {
      "email": super.getEmail,
      "password" : super.getPassword
    };
  }
}