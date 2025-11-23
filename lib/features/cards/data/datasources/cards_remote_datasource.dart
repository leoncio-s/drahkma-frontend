import 'dart:convert';

import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/cards/data/models/card_model.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:requests/requests.dart';
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';

class CardsRemoteDatasource implements Services<CardModel> {

  final String url = "${Config.urlApi}cards";


  @override
  Future get() async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var request = await Requests.get(
      url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<CardModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(CardModel.toObject(el));
      }
    }

    return toRet;
  }

  @override
  Future save(CardModel data) async {
      UserModel? user = await AuthRemoteDatasource.getAuthUser();
      var response = await Requests.post(
      url,
      json: data.toMap(),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
    );

    if(response.statusCode == 201){
      return CardModel.toObject(jsonDecode(response.body));
    }else{
      var toRet=jsonDecode(response.body);
      return toRet;
    }
  }
  
  @override
  Future delete(CardModel data) async {
      UserModel? user = await AuthRemoteDatasource.getAuthUser();
      var response = await Requests.delete(
      "$url/${data.id}",
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    if(response.statusCode != 200){
      return jsonDecode(response.body);
    }else{
      return true;
    }
  }
  
  @override
  Future update(CardModel data) async {
      UserModel? user = await AuthRemoteDatasource.getAuthUser();
      var response = await Requests.put(
      url,
      json: data.toMap(),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'});

      if(response.statusCode != 200){
        var toRet = jsonDecode(response.body);
        return toRet;
      }else{
        var toRet = CardModel.toObject(jsonDecode(response.body));
        return toRet;
      }
  }
}