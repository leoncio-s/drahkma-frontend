import 'dart:convert';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:io' as io show Platform;
import 'package:flutter/foundation.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:requests/requests.dart';

class AuthService {

  static UserDto user = UserDto();
  static final Storage _st = window.localStorage;

  static login(String login, String password) async {
    // try{
      
      var req = await Requests.post('${Config.urlApi}auth/login', json: {"email":login, "password": password}, headers: {'Content-type': 'application/json'}, timeoutSeconds: 60, verify: false);
       

      if(req.statusCode == 500){
        return {"errors" : "Internal server error"};
      }else if(req.statusCode != 200){
        return req.json();
      }else{
        // dynamic json = jsonDecode(req.body);

        return _storage(req.body);
      }
    // }on Exception catch(e){
    //   print(e);
    // }catch(error){
    //   print(error);
    // }
  }

  static _storage(String data){
    if(kIsWeb){
      _st['auth_token'] = data;
      user = user.toObject(jsonDecode(data));
      return user;
    }else if(io.Platform.isWindows){
      user = user.toObject(jsonDecode(data));
      return user;
    }
    
    return jsonDecode(data);
  }

  static Future<UserDto?> getAuthUser() async {
    if(kIsWeb){
      String? data = _st['auth_token'];

      if(data == null){
        return null;
      }
      user = user.toObject(jsonDecode(data));
      return user;
      
    }else if(io.Platform.isWindows){
      return user;
    }

    return null;
  }

  static logout(){
    user = new UserDto();
    if(kIsWeb){
      _st.clear();
    }else if(io.Platform.isWindows){
      user = UserDto();
    }
  }
}