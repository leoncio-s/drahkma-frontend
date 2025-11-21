import 'dart:convert';
import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/Exceptions/unauthenticated_exception.dart';
import 'package:drahkma/Exceptions/update_password_exception.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:requests/requests.dart';

class UserService {
  static Future<UserDto?> profile() async {
    var data = await AuthService.getAuthUser();
    var request = await Requests.get("${Config.urlApi}user", headers: {
      'Authorization': " Bearer ${data?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (request.statusCode != 200) {
      throw UnauthenticatedException();
    }
    var user = UserDto();
    user = user.toObject(jsonDecode(request.body));
    user.token = data!.token;
    AuthService.updateAuthUser(user);
    return user;
  }

  static Future<dynamic> register(Map data) async {
    try {
      var request = await Requests.post("${Config.urlApi}user",
          json: data,
          headers: {'Content-type': 'application/json'});

      if (request.statusCode == 201) {
        return UserDto().toObject(request.json());
      } else {
        return request.json();
      }
    } catch (e) {
      return {"error": "Erro ao processar solicitação."};
    }
  }

  static Future<dynamic> update(UserDto user) async
  {
    try{
      UserDto? userAuth = await AuthService.getAuthUser();
      var request = await Requests.put(
        "${Config.urlApi}user", 
        json: user.toMap(user), 
        headers: {
          'Content-type': 'application/json', 
          'Authorization' :  " Bearer ${userAuth?.token ?? ''}",
        }
        );

      if(request.statusCode == 401){
        throw UnauthenticatedException();
      }else if(request.statusCode == 200){
        user.token = userAuth!.token;
        AuthService.updateAuthUser(user);
        return true;
      }
      else{
        return request.json();
      }
    }on UnauthenticatedException{
      rethrow;
    }catch(e){
      rethrow;
    }
  }

  static Future<Map> updatePassword(String password, String newPassword, String confNewPassword) async
  {
    UserDto? authUser = await AuthService.getAuthUser();
    var data = {
      'password': password,
      'new_password': newPassword,
      'conf_new_password': confNewPassword
    };
    var request = await Requests.put(
        "${Config.urlApi}user/password", 
        json: data, 
        headers: {
          'Content-type': 'application/json', 
          'Authorization' :  " Bearer ${authUser?.token ?? ''}",
        }
    );

    if(request.statusCode == 401)
    {
      throw UnauthenticatedException();
    }
    if(request.statusCode == 200)
    {
      return {"success": true};
    }else if(request.statusCode==422){
      return {"success": false, "message":request.json()['message']};
    }else{
      throw UpdatePasswordException(request.json().toString());
    }
  }
}
