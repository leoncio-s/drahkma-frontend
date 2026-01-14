import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';

abstract interface class AuthRemoteDatasource
{
  Future<User?> login(Auth auth);
  Future<bool> checkSession(User user);
  Future<Map<String, dynamic>?> forgetPassword(String email);
}