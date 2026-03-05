import 'package:drahkma/core/data/sources/app_check_network_datasource.dart';
import 'package:drahkma/core/domain/repositories/app_repository.dart';

class AppRespositoryImpl implements AppRepository
{
  final AppCheckNetworkDatasource _datasource;
  const AppRespositoryImpl(this._datasource);
  @override
  Future<bool?> ckeckNetworkConnection() async {
    return await _datasource.checkNetwork();
  }
  
}