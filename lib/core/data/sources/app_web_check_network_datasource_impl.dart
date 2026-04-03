import 'package:drahkma/core/data/sources/app_check_network_datasource.dart';
import 'package:http/http.dart' as http;

class AppWebCheckNetworkDatasourceImpl implements AppCheckNetworkDatasource
{
  @override
  Future<bool?> checkNetwork() async {
    try{
      var result = await http.get(Uri.parse("https://api.github.com")).timeout(Duration(seconds: 10));
      if(result.statusCode==200)
      {
        return true;
      }else{
        return false;
      }
    }on http.ClientException catch(_)
    {
      return false;
    }catch(e)
    {
      return false;
    }
  }
  
}