import 'dart:io';

import 'package:drahkma/core/data/sources/app_check_network_datasource.dart';

class AppWindowsCheckNetworkDatasourceImpl implements AppCheckNetworkDatasource
{
  @override
  Future<bool?> checkNetwork() async {
    try{
      var result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 10));
      if(result.isNotEmpty && result.first.rawAddress.isNotEmpty)
      {
        return true;
      }
    }on SocketException catch(_)
    {
      return false;
    }
    return false;
  }
  
}