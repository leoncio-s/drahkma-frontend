import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/config.dart';
import 'package:drahkma/dashboard/dashboard_dto.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:requests/requests.dart';

class DashServices {
  
  Future<DashboardDto?> getAmounts(DateTime st, DateTime fn) async {
    var user = await AuthService.getAuthUser();
    var start = DateFormat('yyyyMMdd').format(st);
    var end = DateFormat('yyyyMMdd').format(fn);
    Response response = await Requests.get("${Config.urlApi}item/amounts", headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
    queryParameters: {
      "start_date": start,
      "finish_date" : end
    });

    if(response.statusCode == 200){
      DashboardDto dash = DashboardDto.fromJson(response.json());
 
      return dash;
    }

    return null;
  }
}