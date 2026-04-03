import 'dart:convert';

import 'package:drahkma/core/error/unauthenticated_exception.dart';
import 'package:drahkma/core/error/update_password_exception.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/data/sources/user_remote_datasource.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class UserRemoteDatasourceImpl implements UserRemoteDatasource{

  final AuthLocalDatasource _authLocalSource;
  static final Uri _url = Uri.parse("${Config.urlApi}user");

  UserRemoteDatasourceImpl(AuthLocalDatasource authLocalDatasource) : _authLocalSource = authLocalDatasource;

  @override
  Future<UserModel?> profile() async {
    User? loggedUser = await _authLocalSource.getAuthToken();
    loggedUser as UserModel?;

    if(loggedUser == null) return null;

    var request = await http.get(_url, headers: {
      'Authorization': " Bearer ${loggedUser.token ?? ''}",
      'Content-type': 'application/json',
    }).timeout(Duration(seconds: 10));

    if (request.statusCode != 200) {
      throw UnauthenticatedException();
    }
    var user = UserModel();
    var json = jsonDecode(request.body);
    user = UserModel.fromJson(json);
    user.token = loggedUser.token;
    return user;
  }

  @override
  Future<UserModel?> save(User data) async {
    try {
      var request = await http.post(_url,
          body: jsonEncode((data as UserDTO).toMap()),
          headers: {'Content-type': 'application/json'})
          .timeout(Duration(seconds: 20));

      late Map json;
      if (request.statusCode == 201) {
        json = jsonDecode(request.body);
        return UserModel.fromJson(json);
      } else if (request.statusCode == 400) {
        json = jsonDecode(request.body);
        throw ArgumentError(jsonEncode(json), 'Erro(s) na validação do cadastro');
      }
      throw Exception("Erro interno no servidor");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> update(User user) async
  {
    try{
      User? loggedUser = await _authLocalSource.getAuthToken();
      loggedUser as UserModel?;

      if(loggedUser == null) throw UnauthenticatedException();

      var request = await http.put(
        _url, 
        body: jsonEncode((user as UserDTO).toMap()),
        headers: {
          'Content-type': 'application/json', 
          'Authorization' :  " Bearer ${loggedUser.token ?? ''}",
        }
        )
        .timeout(Duration(seconds: 10));

      if(request.statusCode == 401){
        throw UnauthenticatedException();
      }else if(request.statusCode == 200){
        user.token = loggedUser.token;
        getIt<AuthLocalDatasource>().saveAuthToken(user);
        return;
      }
      else if(request.statusCode == 304)
      {
        return;
      }
      else if(request.statusCode == 400)
      {
        var json = jsonDecode(request.body);
        throw ArgumentError(json.toString(), 'Erro(s) na validação do cadastro');
      }
      throw Exception("Erro interno no servidor");
    }on UnauthenticatedException{
      rethrow;
    }catch(e){
      
      rethrow;
    }
  }

  @override
  Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmNewPassword}) async
  {

    User? loggedUser = await _authLocalSource.getAuthToken();
    loggedUser as UserModel?;

    if(loggedUser == null) throw UnauthenticatedException();

    var data = {
      'password': currentPassword,
      'new_password': newPassword,
      'conf_new_password': confirmNewPassword
    };

    var request = await http.put(
        _url.resolve('/password'), 
        body: jsonEncode(data), 
        headers: {
          'Content-type': 'application/json', 
          'Authorization' :  " Bearer ${loggedUser.token ?? ''}",
        }
    ).timeout(Duration(seconds: 20));

    Map json;
    
    if(request.statusCode == 401)
    {
      throw UnauthenticatedException();
    }else if(request.statusCode == 200)
    {
      return;
    }else if(request.statusCode==422){
      json = jsonDecode(request.body);
      throw UpdatePasswordException(json.toString());
    }else{
      json = jsonDecode(request.body);
      throw UpdatePasswordException(json.toString());
    }
  }
}
