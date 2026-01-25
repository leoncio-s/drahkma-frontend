import 'package:drahkma/features/user/data/sources/user_remote_datasource.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:drahkma/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository
{
  final UserRemoteDatasource _datasource;
  UserRepositoryImpl(UserRemoteDatasource datasource) : _datasource=datasource;
  
  @override
  Future<User?> profile() async {
    User? user = await _datasource.profile();
    return user;
  }

  @override
  Future<User?> save(User user) async {
    User? savedUser = await _datasource.save(user);
    return savedUser;
  }

  @override
  Future<void> update(User user) async {
    await _datasource.update(user);
  }

  @override
  Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmNewPassword}) async {
    await _datasource.updatePassword(currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword);
  }
  
}