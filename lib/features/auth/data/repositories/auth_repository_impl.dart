import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/auth/data/sources/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository
{
  final AuthLocalDatasource _localDatasource;
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._localDatasource, this._remoteDatasource);

  @override
  Future<User?> checkSession() async {
    var authToken = (await _localDatasource.getAuthToken());
    if(authToken == null) return null;
    var result = await _remoteDatasource.checkSession(authToken);
    if (result)
    {
      return authToken;
    }
    return null;
  }

  @override
  Future<User?> login({required Auth auth}) async {
    User? ret = await _remoteDatasource.login(auth);
    await _localDatasource.saveAuthToken(ret as User);
    await _localDatasource.saveStorageEmail(auth.getEmail!);
    return ret;
  }

  @override
  Future<void> logout() async {
    await _localDatasource.clearAuthToken();
  }

  @override
  Future<String?> getLocalSavedEmail() async {
    return await _localDatasource.getStorageEmail();
  }

}