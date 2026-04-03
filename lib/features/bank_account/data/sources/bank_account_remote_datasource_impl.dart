import 'dart:convert';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_dto.dart';
import 'package:drahkma/features/bank_account/data/models/bank_model.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/data/sources/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class BankAccountRemoteDatasourceImpl implements BankAccountRemoteDatasource {
  static final Uri _url = Uri.parse("${Config.urlApi}banks");

  @override
  Future<List<BankAccountModel>> getAll() async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<BankAccountModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(BankAccountModel.fromJson(el));
      }
    }

    return toRet;
  }

  @override
  Future<BankAccountModel?> save(data) async {
    (data as BankAccountDTO);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var response = await http.post(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return BankAccountModel.fromJson(jsonDecode(response.body));
    } else {
      var toRet = jsonDecode(response.body);
      return toRet;
    }
  }

  @override
  Future delete(BankAccount data) async {
    (data as BankAccountDTO);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var response = await http.delete(
      _url.resolve("/${data.id}"),
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
    (data as BankAccountDTO);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var response = await http.put(
      _url, 
      body: jsonEncode(data.toMap()), 
      headers: {
      'Authorization': " Bearer ${user?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode != 200) {
      var toRet = jsonDecode(response.body);
      return toRet;
    } else {
      var toRet = BankAccountModel.fromJson(jsonDecode(response.body));
      return toRet;
    }
  }

  @override
  Future<List<BankModel>?> getBanks() async {
    http.Response response =
        await http.get(Uri.parse("https://brasilapi.com.br/api/banks/v1"));

    if (response.statusCode == 200) {
      List json = jsonDecode(response.body);
      List<BankModel> banks =
          json.map((item) => BankModel.fromJson(item)).toList();

      return banks;
    }

    return null;
  }
  
  @override
  Future<BankAccount?> get({id}) {
    throw UnimplementedError();
  }
}
