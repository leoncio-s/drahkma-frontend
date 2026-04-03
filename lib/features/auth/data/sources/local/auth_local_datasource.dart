import 'package:drahkma/features/user/domain/entities/user.dart';

abstract interface class AuthLocalDatasource {
  Future<void> saveAuthToken(User user);
  Future<User?> getAuthToken();
  Future<void> clearAuthToken();
  Future<void> saveStorageEmail(String email);
  Future<String?> getStorageEmail();
  
}