import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';

abstract interface class AuthRepository {

  Future<User?> login({required Auth auth});
  Future<User?> checkSession();
  Future<void> logout();
}