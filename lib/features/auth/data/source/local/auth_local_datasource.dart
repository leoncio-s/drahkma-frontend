import 'package:drahkma/features/users/data/models/user_model.dart';

interface class AuthLocalDatasource {
  Future<void> saveAuthToken(UserModel user) {
    throw UnimplementedError();
  }

  Future<UserModel?> getAuthToken() {
    throw UnimplementedError();
  }
  
  Future<void> clearAuthToken() {
    throw UnimplementedError();
  }
  
}