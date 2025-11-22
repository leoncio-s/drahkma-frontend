import 'dart:convert';

import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank.dart';
import 'package:drahkma/features/bank_accounts/data/models/bank_accounts.dart';
import 'package:drahkma/features/users/data/models/user.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as hp;
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';

class BankAccountsRemoteDatasource implements Services<BankAccounts> {
  String url = "${Config.urlApi}banks";

  @override
  Future<List<BankAccounts>> get() async {
    User? user = await AuthRemoteDatasource.getAuthUser();
    var request = await Requests.get(
      url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<BankAccounts>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(BankAccounts.toObject(el));
      }
    }

    return toRet;
  }

  @override
  Future save(BankAccounts data) async {
    User? user = await AuthRemoteDatasource.getAuthUser();
    var response = await Requests.post(
      url,
      json: data.toMap(),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return BankAccounts.toObject(jsonDecode(response.body));
    } else {
      var toRet = jsonDecode(response.body);
      return toRet;
    }
  }

  @override
  Future delete(BankAccounts data) async {
    User? user = await AuthRemoteDatasource.getAuthUser();
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
    User? user = await AuthRemoteDatasource.getAuthUser();
    var response = await Requests.put(url, json: data.toMap(), headers: {
      'Authorization': " Bearer ${user?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode != 200) {
      var toRet = jsonDecode(response.body);
      return toRet;
    } else {
      var toRet = BankAccounts.toObject(jsonDecode(response.body));
      return toRet;
    }
  }

  Future<List<Banks>?> getBanks() async {
    hp.Response response =
        await hp.get(Uri.parse("https://brasilapi.com.br/api/banks/v1"));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      List<Banks> banks =
          json.map((item) => Banks.fromJson(item)).toList();

      return banks;
    }

    return null;
  }
}
