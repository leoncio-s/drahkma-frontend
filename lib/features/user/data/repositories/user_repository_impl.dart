import 'package:drahkma/features/user/data/sources/remote/user_remote_datasource.dart';
import 'package:drahkma/features/user/data/sources/local/user_local_datasource.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:drahkma/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository
{
  final UserRemoteDatasource _remoteDatasource;
  final UserLocalDatasource _localDatasource;
  
  UserRepositoryImpl(UserRemoteDatasource remoteDatasource, UserLocalDatasource localDatasource) 
    : _remoteDatasource = remoteDatasource,
      _localDatasource = localDatasource;
  
  @override
  Future<User?> profile() async {
    try {
      User? user = await _remoteDatasource.profile();
      if (user != null) {
        await _localDatasource.saveUser(user);
      }
      return user;
    } catch (e) {
      // Fallback to local datasource on network error
      return await _localDatasource.getUser();
    }
  }

  @override
  Future<User?> save(User user) async {
    try {
      User? savedUser = await _remoteDatasource.save(user);
      if (savedUser != null) {
        await _localDatasource.saveUser(savedUser);
      }
      return savedUser;
    } catch (e) {
      // Fallback to local datasource on network error
      return await _localDatasource.getUser();
    }
  }

  @override
  Future<void> update(User user) async {
    try {
      await _remoteDatasource.update(user);
      await _localDatasource.saveUser(user);
    } catch (e) {
      // On network error, at least save to local
      await _localDatasource.saveUser(user);
      rethrow;
    }
  }

  @override
  Future<void> updatePassword({required String currentPassword, required String newPassword, required String confirmNewPassword}) async {
    await _remoteDatasource.updatePassword(currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword);
  }
  
}