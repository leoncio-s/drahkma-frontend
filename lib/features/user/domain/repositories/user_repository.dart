import 'package:drahkma/features/user/domain/entities/user.dart';

abstract class UserRepository{
  Future<User?> profile();
  Future<void> update(User user);
  Future<User?> save(User user);
  Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmNewPassword});
}