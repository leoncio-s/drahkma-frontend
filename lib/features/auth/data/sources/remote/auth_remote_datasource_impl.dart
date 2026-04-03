import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/error/invalid_credentials_exception.dart';
import 'package:drahkma/core/error/user_not_allowed_exception.dart';
import 'package:drahkma/features/auth/data/models/auth_model.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  static final Uri _url = Uri.parse("${Config.urlApi}auth");

  @override
  Future<UserModel?> login(Auth auth) async {
    var url = _url.replace(pathSegments: [..._url.pathSegments, 'login']);
    final response = await http.post(
      url,
      body: jsonEncode((auth as AuthModel).toMap()),
      headers: {'Content-type': 'application/json'},
    ).timeout(Duration(seconds: 15), onTimeout: () => throw TimeoutException("Servidou demorou para responder"),);

    late Map json;
    if (response.statusCode == 200) {
      json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else if (response.statusCode == 400 || response.statusCode == 404) {
      json = jsonDecode(response.body);
      throw InvalidCredentialsException(
          json['message'] ?? "Email ou senha inválidos.");
    } else if (response.statusCode == 403) {
      throw UserNotAllowedException();
    } else {
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> forgetPassword(String email) async {
    var url = _url.replace(pathSegments: [..._url.pathSegments, 'forget-password']);
    var req = await http.post(url,
        body: jsonEncode({"email": email}),
        headers: {'Content-type': 'application/json'})
        .timeout(Duration(seconds: 15), onTimeout: ()=>throw TimeoutException("Servidor demorou para responder"));

    late Map<String, dynamic> json;
    if (req.statusCode == 200) {
      json = jsonDecode(req.body);
      return json;
    } else if (req.statusCode != 200) {
      json = jsonDecode(req.body);
      throw ArgumentError(json['message']);
    } else {
      throw Exception("Erro interno no servidor");
    }
  }

  Future<Map> forgetPasswordCode(
      String email, String code, String password, String confPassword) async {
    
    var url = _url.replace(pathSegments: [..._url.pathSegments, 'forget-password/$email']);
    var req = await http.post(url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode({
          'code': code,
          'password': password,
          'confpassword': confPassword
        })).timeout(Duration(seconds: 20));

    late Map json;
    if (req.statusCode == 200) {
      json = jsonDecode(req.body);
      return json;
    } else {
      json = jsonDecode(req.body);
      if (json['message'] != null) {
        return {'error': json['message']};
      }
      return json;
    }
  }

  @override
  Future<bool> checkSession(User data) async {
    data = data as UserModel;

    try{
      var request = await http.get(Uri.parse("${Config.urlApi}user"), headers: {
      'Authorization': " Bearer ${data.token ?? ''}",
      'Content-type': 'application/json'
      }).timeout(Duration(seconds: 10), onTimeout: (){
        throw TimeoutException("O servidor demorou para responder");
      });
      if (request.statusCode == 200) {
      return true;
    }

    }on SocketException catch (_){
      rethrow;
    }on http.ClientException catch (_)
    {
      rethrow;
    }catch(_)
    {
      rethrow;
    }
    return false;
  }
}
