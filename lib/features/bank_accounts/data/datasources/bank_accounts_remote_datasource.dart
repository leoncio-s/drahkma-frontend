import 'dart:convert';

import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank_model.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank_accounts_model.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as hp;
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';

class BankAccountsRemoteDatasource implements Services<BankAccountModel> {
  String url = "${Config.urlApi}banks";

  @override
  Future<List<BankAccountModel>> get() async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var request = await Requests.get(
      url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<BankAccountModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(BankAccountModel.toObject(el));
      }
    }

    return toRet;
  }

  @override
  Future save(BankAccountModel data) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var response = await Requests.post(
      url,
      json: data.toMap(),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return BankAccountModel.toObject(jsonDecode(response.body));
    } else {
      var toRet = jsonDecode(response.body);
      return toRet;
    }
  }

  @override
  Future delete(BankAccountModel data) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var response = await Requests.delete(
      "$url/${data.id}",
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    if (response.statusCode != 200) {
      return jsonDecode(response.body);
    } else {
      return true;
    }
  }

  @override
  Future update(data) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var response = await Requests.put(url, json: data.toMap(), headers: {
      'Authorization': " Bearer ${user?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode != 200) {
      var toRet = jsonDecode(response.body);
      return toRet;
    } else {
      var toRet = BankAccountModel.toObject(jsonDecode(response.body));
      return toRet;
    }
  }

  Future<List<BankModel>?> getBanks() async {
    hp.Response response =
        await hp.get(Uri.parse("https://brasilapi.com.br/api/banks/v1"));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      List<BankModel> banks =
          json.map((item) => BankModel.fromJson(item)).toList();

      return banks;
    }

    return null;
  }
}
