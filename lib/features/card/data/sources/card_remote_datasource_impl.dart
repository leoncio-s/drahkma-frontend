import 'dart:convert';
import 'dart:io';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/cards/data/models/cards_dto.dart';
import 'package:drahkma/features/cards/data/models/cards_model.dart';
import 'package:drahkma/features/cards/data/sources/cards_remote_datasource.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class CardsRemoteDatasourceImpl implements CardsRemoteDatasource{

  static final Uri _url = Uri.parse("${Config.urlApi}cards");


  @override
  Future<List<CardsModel>?> getAll() async {
    UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<CardsModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(CardsModel.fromJson(el));
      }
    }
    return toRet;
  }

  @override
  Future<CardsModel?> save(CardsDTO data) async {
      UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
      var response = await http.post(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
    );

    if(response.statusCode == 201){
      return CardsModel.fromJson(jsonDecode(response.body));
    }else{
      var toRet=jsonDecode(response.body);
      return toRet;
    }
  }
  
  @override
  Future<void> delete(CardsModel data) async {
      UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
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
  Future<void> update(CardsDTO data) async {
      UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
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
  Future<CardsModel?> getBy({int? id}) async {
      UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
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
        CardsModel card = CardsModel.fromJson(json);
        return card;
      }
  }
}