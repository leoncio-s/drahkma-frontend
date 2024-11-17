import 'dart:convert';

import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/Cards/cards_dto.dart';
import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:requests/requests.dart';

class CardsServices implements Services<CardsDto> {

  final String url = "${Config.urlApi}cards";


  @override
  Future get() async {
    UserDto? user = await AuthService.getAuthUser();
    var request = await Requests.get(
      url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<CardsDto>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(CardsDto.toObject(el));
      }
    }

    return toRet;
  }

  @override
  Future save(CardsDto data) async {
      UserDto? user = await AuthService.getAuthUser();
      var response = await Requests.post(
      url,
      json: data.toMap(),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
    );

    if(response.statusCode == 201){
      return CardsDto.toObject(jsonDecode(response.body));
    }else{
      var toRet=jsonDecode(response.body);
      return toRet;
    }
  }
  
  @override
  Future delete(CardsDto data) async {
      UserDto? user = await AuthService.getAuthUser();
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
  Future update(CardsDto data) async {
      UserDto? user = await AuthService.getAuthUser();
      var response = await Requests.put(
      url,
      json: data.toMap(),
      headers: {'Authorization': " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'});

      if(response.statusCode != 200){
        var toRet = jsonDecode(response.body);
        return toRet;
      }else{
        var toRet = CardsDto.toObject(jsonDecode(response.body));
        return toRet;
      }
  }
}