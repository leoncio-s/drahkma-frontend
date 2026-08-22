import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

abstract class UserRepository{
  Future<User?> profile();
  Future<void> update(User user);
  Future<User?> save(UserDTO user);
  Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmNewPassword});
}