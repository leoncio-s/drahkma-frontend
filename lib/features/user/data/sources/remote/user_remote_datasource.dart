import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

abstract interface class UserRemoteDatasource {
  Future<User?> profile();
  Future<void> update(User user);
  Future<User?> save(UserDTO user);
  Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmNewPassword});
}