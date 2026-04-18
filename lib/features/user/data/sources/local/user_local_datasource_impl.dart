import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/user/data/mappers/user_mapper.dart';
import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:drahkma/features/user/data/sources/local/user_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDatasourceImpl implements UserLocalDatasource {
  final SharedPreferencesAsync storage;

  UserLocalDatasourceImpl({required this.storage});

  @override
  Future<void> saveUser(covariant User user) async {
    UserDTO userDTO = UserDTO.fromModel(user as UserModel);
    await storage.setString(
        Config.keyStorageUser,
        JsonEncoder().convert(userDTO.toMap()));
  }

  @override
  Future<User?> getUser() async {
    String? jsonString = await storage.getString(Config.keyStorageUser);
    if (jsonString != null) {
      var json = JsonDecoder().convert(jsonString);
      UserModel model = UserModel.fromJson(json);
      return UserMapper.toEntity(model);
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await storage.remove(Config.keyStorageUser);
  }
}
