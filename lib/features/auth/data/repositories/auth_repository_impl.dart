import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/auth/data/source/remote/auth_remote_datasource.dart';
import 'package:drahkma/features/auth/domain/entities/auth.dart';
import 'package:drahkma/features/auth/domain/repositories/auth_repository.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository
{
  final AuthLocalDatasource _localDatasource;
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._localDatasource, this._remoteDatasource);

  @override
  Future<User?> checkSession() async {
    if (await _remoteDatasource.checkSession((await _localDatasource.getAuthToken()) as User))
    {
      return _localDatasource.getAuthToken();
    }
    return null;
  }

  @override
  Future<User?> login({required Auth auth}) async {
    User? ret = await _remoteDatasource.login(auth);
    _localDatasource.saveAuthToken(ret as UserModel);
    return ret;
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

}