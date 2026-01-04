import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {

  final SharedPreferencesAsync storage;

  AuthLocalDatasourceImpl({required this.storage});

  @override
  Future<UserModel?> getAuthToken() async {
    String? token = await storage.getString(Config.keyStorageAuthToken);
    if (token != null) {
      var json = JsonDecoder().convert(token);
      return UserModel.toObject(json);
    }
    return null;
  }

  @override
  Future<void> saveAuthToken(UserModel user) async {
    storage.setString(
        Config.keyStorageAuthToken,
        JsonEncoder().convert(user.toMap()));
    return;
  }
  
  @override
  Future<void> clearAuthToken() async {
    await storage.remove(Config.keyStorageAuthToken);
    return;
  }

  Future<String?> getStorageEmail() async {
    return await storage.getString('email');
  }
}