
import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/amounts/data/models/dashboard.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:requests/requests.dart';
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';

class AmountRemoteDatasource {
  
  Future<Dashboard?> getAmounts(DateTime st, DateTime fn) async {
    var user = await AuthRemoteDatasource.getAuthUser();
    var start = DateFormat('yyyyMMdd').format(st);
    var end = DateFormat('yyyyMMdd').format(fn);
    Response response = await Requests.get("${Config.urlApi}item/amounts", headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
    queryParameters: {
      "start_date": start,
      "finish_date" : end
    });

    if(response.statusCode == 200){
      Dashboard dash = Dashboard.fromJson(response.json());
 
      return dash;
    }

    return null;
  }
}