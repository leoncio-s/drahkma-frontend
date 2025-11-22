import 'dart:convert';
import 'package:drahkma/core/exceptions/unauthenticated_exception.dart';
import 'package:drahkma/core/exceptions/update_password_exception.dart';
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:drahkma/config.dart';
import 'package:drahkma/features/users/data/models/user.dart';
import 'package:requests/requests.dart';

class UserRemoteDatasource {
  static Future<User?> profile() async {
    var data = await AuthRemoteDatasource.getAuthUser();
    var request = await Requests.get("${Config.urlApi}user", headers: {
      'Authorization': " Bearer ${data?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (request.statusCode != 200) {
      throw UnauthenticatedException();
    }
    var user = User();
    user = user.toObject(jsonDecode(request.body));
    user.token = data!.token;
    AuthRemoteDatasource.updateAuthUser(user);
    return user;
  }

  static Future<dynamic> register(Map data) async {
    try {
      var request = await Requests.post("${Config.urlApi}user",
          json: data,
          headers: {'Content-type': 'application/json'});

      if (request.statusCode == 201) {
        return User().toObject(request.json());
      } else {
        return request.json();
      }
    } catch (e) {
      return {"error": "Erro ao processar solicitação."};
    }
  }

  static Future<dynamic> update(User user) async
  {
    try{
      User? userAuth = await AuthRemoteDatasource.getAuthUser();
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
        AuthRemoteDatasource.updateAuthUser(user);
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
    User? authUser = await AuthRemoteDatasource.getAuthUser();
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
