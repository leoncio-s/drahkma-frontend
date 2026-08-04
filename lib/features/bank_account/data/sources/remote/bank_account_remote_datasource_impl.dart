import 'dart:convert';
import 'dart:io';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/data/models/unprocessable_entity_model.dart';
import 'package:drahkma/core/error/invalid_credentials_exception.dart';
import 'package:drahkma/core/error/unprocessable_entity_exception.dart';
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

  final http.Client client;
  BankAccountRemoteDatasourceImpl(this.client);

  @override
  Future<List<BankAccount>?> getAll() async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var request = await client.get(
      _url,
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
    );

    List<BankAccountModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(BankAccountModel.fromJson(el));
      }
    } else if (request.statusCode == 401) {
      throw InvalidCredentialsException("Unauthenticated");
    }

    return toRet;
  }

  @override
  Future<BankAccount?> save(data) async {
    var dataDto = BankAccountMapper.fromEntityToDTO(data);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var response = await client.post(
      _url,
      body: jsonEncode(dataDto.toMap()),
      headers: {
        'Authorization': " Bearer ${userModel?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (response.statusCode == 201) {
      return BankAccountMapper.toEntity(
          BankAccountModel.fromJson(jsonDecode(response.body)));
    } else if (response.statusCode == 401) {
      throw InvalidCredentialsException("Unauthenticated");
    } else if(response.statusCode == 422 || response.statusCode == 400) {
      var toRet = jsonDecode(response.body);
      throw UnprocessableEntityException(
          error: UnprocessableEntityModel.fromJson(toRet));
    }else{
      var toRet = jsonDecode(response.body);
      throw HttpException(toRet['message'] ?? response.statusCode.toString());
    }
  }

  @override
  Future<void> delete(BankAccount data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var url = joinUrl(_url, "${data.id}");
    var response = await client.delete(
      url,
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
    );

    if (response.statusCode == 200){
      return;
    }else if (response.statusCode == 401) {
      throw InvalidCredentialsException("Unauthenticated");
    } else{
      var json = jsonDecode(response.body);
      throw HttpException(json['error'] ?? json['message']);
    }
  }

  @override
  Future<void> update(data) async {
    var dataDTO = BankAccountMapper.fromEntityToDTO(data);
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    var response =
        await client.put(_url, body: jsonEncode(dataDTO.toMap()), headers: {
      'Authorization': " Bearer ${userModel?.token ?? ''}",
      'Content-type': 'application/json'
    });

    if (response.statusCode == 401) {
      throw InvalidCredentialsException("Unauthenticated");
    } else if (response.statusCode == 200) {
      return;
    } else if(response.statusCode == 422 || response.statusCode == 400) {
      var toRet = jsonDecode(response.body);
      throw UnprocessableEntityException(
          error: UnprocessableEntityModel.fromJson(toRet));
    }else{
      var toRet = jsonDecode(response.body);
      throw HttpException(toRet['message'] ?? response.statusCode.toString());
    }
  }

  @override
  Future<List<BankModel>?> getBanks() async {
    http.Response response =
        await client.get(Uri.parse("https://brasilapi.com.br/api/banks/v1"));

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
