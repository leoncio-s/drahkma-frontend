import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/amount/data/sources/remote/amount_remote_datasource.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AmountRemoteDatasourceImpl implements AmountRemoteDatasource 
{
  final _url = Uri.parse("${Config.urlApi}item/amounts");
  @override
  Future<Map<String, dynamic>?> fetchAmounts(DateTime startDate, DateTime endDate) async {
    var user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var start = DateFormat('yyyyMMdd').format(startDate);
    var end = DateFormat('yyyyMMdd').format(endDate);

    var response = await http.get(_url.replace(queryParameters: {"start_date": start, "finish_date": end}),
        headers: {'Authorization': " Bearer ${user!.token ?? ''}"});

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      return json;
    }

    return null;
  }
}
