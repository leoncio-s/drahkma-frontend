import 'package:drahkma/features/user/domain/entities/user.dart';

abstract interface class UserLocalDatasource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> clearUser();
}
