import 'dart:convert';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/utils/helpers/join_url.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/bank_account/data/mappers/bank_account_mapper.dart';
import 'package:drahkma/features/bank_account/data/models/bank_model.dart';
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class BankAccountRemoteDatasourceImpl implements BankAccountRemoteDatasource {
  static final Uri _url = Uri.parse("${Config.urlApi}banks");

  @override
  Future<List<BankAccount>?> getAll() async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
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
  Future<BankAccount?> save(data) async {
    var dataDto = BankAccountMapper.fromEntityToDTO(data);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var response = await http.post(
      _url,
      body: jsonEncode(dataDto.toMap()),
      headers: {
        'Authorization': " Bearer ${userModel?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return BankAccountMapper.toEntity(BankAccountModel.fromJson(jsonDecode(response.body)));
    } else {
      var toRet = jsonDecode(response.body);
      return toRet;
    }
  }

  @override
  Future delete(BankAccount data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var url = joinUrl(_url, "${data.id}");
    var response = await http.delete(
      url,
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
    );

    if (response.statusCode != 200) {
      var json = jsonDecode(response.body);
      throw http.ClientException(json['error']);
    } else {
      return true;
    }
  }

  @override
  Future update(data) async {
    var dataDTO = BankAccountMapper.fromEntityToDTO(data);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var response = await http.put(
      _url, 
      body: jsonEncode(dataDTO.toMap()),
      headers: {
      'Authorization': " Bearer ${userModel?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode != 200) {
      var toRet = jsonDecode(response.body);
      throw http.ClientException(toRet['error']);
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
