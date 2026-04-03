import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {

  final SharedPreferencesAsync storage;

  AuthLocalDatasourceImpl({required this.storage});

  @override
  Future<UserModel?> getAuthToken() async {
    String? token = await storage.getString(Config.keyStorageAuthToken);
    if (token != null) {
      var json = JsonDecoder().convert(token);
      UserModel user = UserModel.fromJson(json);
      return user;
    }
    return null;
  }

  @override
  Future<void> saveAuthToken(User user) async {
    UserDTO userDTO = UserDTO.fromModel(user as UserModel);
    storage.setString(
        Config.keyStorageAuthToken,
        JsonEncoder().convert(userDTO.toMap()));
    return;
  }
  
  @override
  Future<void> clearAuthToken() async {
    await storage.remove(Config.keyStorageAuthToken);
    return;
  }

  @override
  Future<String?> getStorageEmail() async {
    var email = await storage.getString(Config.keyStorageEmail);
    return email;
  }

  @override
  Future<void> saveStorageEmail(String email) async
  {
    await storage.setString(Config.keyStorageEmail, email);
  }
}