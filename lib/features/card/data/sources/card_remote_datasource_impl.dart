import 'dart:convert';
import 'dart:io';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/card/data/models/card_dto.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/data/sources/card_remote_datasource.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class CardRemoteDatasourceImpl implements CardRemoteDatasource{

  static final Uri _url = Uri.parse("${Config.urlApi}cards");


  @override
  Future<List<CardModel>?> getAll() async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<CardModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(CardModel.fromJson(el));
      }
    }
    return toRet;
  }

  @override
  Future<CardModel?> save(CardDTO data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
      var response = await http.post(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
    );

    if(response.statusCode == 201){
      return CardModel.fromJson(jsonDecode(response.body));
    }else{
      var toRet=jsonDecode(response.body);
      return toRet;
    }
  }
  
  @override
  Future<void> delete(CardModel data) async {
      User? user = await getIt<AuthLocalDatasource>().getAuthToken();
      user as UserModel?;
      var response = await http.delete(
      _url.resolve("/${data.id}"),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    if(response.statusCode == 404){
      throw http.ClientException("Página ou cartão não encontrado", _url);
    }else if(response.statusCode > 499 || response.statusCode != 200){
      throw HttpException("Erro interno no servidor");
    }else
    {
      return;
    }
  }
  
  @override
  Future<void> update(CardDTO data) async {
      User? user = await getIt<AuthLocalDatasource>().getAuthToken();
      user as UserModel?;
      var response = await http.put(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'});

      if(response.statusCode == 404){
        throw http.ClientException("Página ou cartão não encontrado", _url);
      }else if(response.statusCode > 499 || response.statusCode != 200){
        throw HttpException("Erro interno no servidor");
      }else
      {
        return;
      }
  }
  
  @override
  Future<CardModel?> getBy({int? id}) async {
      User? user = await getIt<AuthLocalDatasource>().getAuthToken();
      user as UserModel?;
      var response = await http.get(
      _url.resolve("/$id"),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'});

      if(response.statusCode == 404){
        throw http.ClientException("Página ou cartão não encontrado", _url);
      }else if(response.statusCode > 499 || response.statusCode != 200){
        throw HttpException("Erro interno no servidor");
      }else
      {
        Map<String, dynamic> json = jsonDecode(response.body);
        CardModel card = CardModel.fromJson(json);
        return card;
      }
  }
}