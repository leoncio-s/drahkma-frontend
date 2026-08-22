import 'dart:convert';

import 'package:drahkma/core/error/unauthenticated_exception.dart';
import 'package:drahkma/core/error/update_password_exception.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/utils/helpers/join_url.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/user/data/mappers/user_mapper.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/data/sources/remote/user_remote_datasource.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class UserRemoteDatasourceImpl implements UserRemoteDatasource{

  final AuthLocalDatasource _authLocalSource;
  static final Uri _url = Uri.parse("${Config.urlApi}user");

  UserRemoteDatasourceImpl(AuthLocalDatasource authLocalDatasource) : _authLocalSource = authLocalDatasource;

  @override
  Future<User?> profile() async {
    UserModel? loggedUser = await _authLocalSource.getAuthToken() as UserModel?;

    if(loggedUser == null) return null;

    UserModel? userModel = loggedUser;
    var request = await http.get(_url, headers: {
      'Authorization': " Bearer ${userModel.token ?? ''}",
      'Content-type': 'application/json',
    }).timeout(Duration(seconds: 10));

    if (request.statusCode != 200) {
      throw UnauthenticatedException();
    }
    var json = jsonDecode(request.body);
    userModel = UserModel.fromJson(json);
    userModel = UserModel(
      id: userModel.id,
      fullname: userModel.fullname,
      email: userModel.email,
      phoneNumber: userModel.phoneNumber,
      actived: userModel.actived,
      emailVerifiedAt: userModel.emailVerifiedAt,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      token: userModel.token
    );
    return userModel;
  }

  @override
  Future<User?> save(UserDTO data) async {
    try {
      var request = await http.post(_url,
          body: jsonEncode((data).toMap()),
          headers: {'Content-type': 'application/json'})
          .timeout(Duration(seconds: 20));

      late Map json;
      if (request.statusCode == 201) {
        json = jsonDecode(request.body);
        return UserModel.fromJson(json) as User?;
      } else if (request.statusCode == 400) {
        json = jsonDecode(request.body);
        throw ArgumentError(jsonEncode(json["errors"]), 'Erro(s) na validação do cadastro');
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
      UserModel? loggedUserModel = loggedUser as UserModel?;

      if(loggedUserModel == null) throw UnauthenticatedException();

      var request = await http.put(
        _url, 
        body: jsonEncode((user as UserDTO).toMap()),
        headers: {
          'Content-type': 'application/json', 
          'Authorization' :  " Bearer ${loggedUserModel.token ?? ''}",
        }
        )
        .timeout(Duration(seconds: 10));

      if(request.statusCode == 401){
        throw UnauthenticatedException();
      }else if(request.statusCode == 200){
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
    UserModel? loggedUserModel = loggedUser as UserModel?;

    if(loggedUserModel == null) throw UnauthenticatedException();

    var data = {
      'password': currentPassword,
      'new_password': newPassword,
      'conf_new_password': confirmNewPassword
    };
    var url = joinUrl(_url, 'password');
    var request = await http.put(
        url,
        body: jsonEncode(data), 
        headers: {
          'Content-type': 'application/json', 
          'Authorization' :  " Bearer ${loggedUserModel.token ?? ''}",
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
