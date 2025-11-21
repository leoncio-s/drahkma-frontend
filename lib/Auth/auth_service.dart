import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
import 'package:web/web.dart';
import 'dart:io' as io show Platform;
import 'package:flutter/foundation.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:requests/requests.dart';

class AuthService {

  static UserDto user = UserDto();
  static final Storage _st = window.localStorage;

  static login(String login, String password) async {
      _st.setItem("email", login);
      var req = await Requests.post('${Config.urlApi}auth/login', json: {"email":login, "password": password}, headers: {'Content-type': 'application/json'}, timeoutSeconds: 60, verify: false);
       
      if(req.statusCode == 500){
        return {"errors" : "Internal server error"};
      }else if(req.statusCode != 200){
        return req.json();
      }else{
        return _storage(req.body);
      }
  }

  static _storage(String data){
    if(kIsWeb){
      _st.setItem('auth_token', data);
      user = user.toObject(jsonDecode(data));
      return user;
    }else if(io.Platform.isWindows){
      user = user.toObject(jsonDecode(data));
      return user;
    }
    
    return jsonDecode(data);
  }

  static String? storageGetEmail(){
    return _st.getItem('email');
  }

  static Future<UserDto?> getAuthUser() async {

    if(kIsWeb){
      String? data = _st.getItem('auth_token');

      if(data == null){
        return null;
      }

      var jsonD = jsonDecode(data.toString());

      user = user.toObject(jsonD);
      
      return user;
      
    }else if(io.Platform.isWindows){
      return user;
    }

    return null;
  }

  static Future<void> updateAuthUser(UserDto user) async
  {
    if(kIsWeb)
    {
      _st.setItem('auth_token', jsonEncode(user.toMap(user)));
    }
  }

  static logout(){
    user = UserDto();
    if(kIsWeb){
      _st.clear();
    }else if(io.Platform.isWindows){
      user = UserDto();
    }
  }

  static Future<Map> forgetPassword(String email) async
  {
      var req = await Requests.post('${Config.urlApi}auth/forget-password', json: {"email":email}, headers: {'Content-type': 'application/json'}, timeoutSeconds: 60, verify: false);

      if(req.statusCode == 500){
        return {"errors" : "Internal server error"};
      }else if(req.statusCode != 200){
        throw Exception(req.json()['error']);
      }else{
        return req.json();
      }
  }

  static Future<Map> forgetPasswordCode(String email, String code, String password, String confPassword) async
  {
    var req = await Requests.post('${Config.urlApi}auth/forget-password/$email', headers: {'Content-type': 'application/json'}, timeoutSeconds: 20, verify: false, json: {'code':code, 'password':password, 'confpassword':confPassword});
    
    if(req.statusCode == 200)
    {
      return req.json();
    }else{
      var json = req.json();
      if (json['message'] != null){
        return {'error':json['message']};
      }
      return json;
    }
  }
}