import 'dart:convert';

import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/BankAccounts/bank_accounts_dto.dart';
import 'package:drahkma/BankAccounts/banks_dto.dart';
import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:requests/requests.dart';
import 'package:http/http.dart' as hp;

class BankAccountsService implements Services<BankAccountsDto> {
  String url = "${Config.urlApi}banks";

  @override
  Future<List<BankAccountsDto>> get() async {
    UserDto? user = await AuthService.getAuthUser();
    var request = await Requests.get(
      url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<BankAccountsDto>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(BankAccountsDto.toObject(el));
      }
    }

    return toRet;
  }

  @override
  Future save(BankAccountsDto data) async {
    UserDto? user = await AuthService.getAuthUser();
    var response = await Requests.post(
      url,
      json: data.toMap(),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return BankAccountsDto.toObject(jsonDecode(response.body));
    } else {
      var toRet = jsonDecode(response.body);
      return toRet;
    }
  }

  @override
  Future delete(BankAccountsDto data) async {
    UserDto? user = await AuthService.getAuthUser();
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
    UserDto? user = await AuthService.getAuthUser();
    var response = await Requests.put(url, json: data.toMap(), headers: {
      'Authorization': " Bearer ${user?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode != 200) {
      var toRet = jsonDecode(response.body);
      return toRet;
    } else {
      var toRet = BankAccountsDto.toObject(jsonDecode(response.body));
      return toRet;
    }
  }

  Future<List<BanksDto>?> getBanks() async {
    hp.Response response =
        await hp.get(Uri.parse("https://brasilapi.com.br/api/banks/v1"));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      List<BanksDto> banks =
          json.map((item) => BanksDto.fromJson(item)).toList();

      return banks;
    }

    return null;
  }
}
