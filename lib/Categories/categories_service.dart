import 'dart:convert';

import 'package:front_lfinanca/Auth/auth_service.dart';
import 'package:front_lfinanca/Categories/categories_dto.dart';
import 'package:front_lfinanca/Interfaces/services.dart';
import 'package:front_lfinanca/User/user_dto.dart';
import 'package:front_lfinanca/config.dart';
import 'package:requests/requests.dart';

class CategoriesService implements Services<CategoriesDto>{

  
  final String url = "${Config.urlApi}categories";

  @override
  Future<List<CategoriesDto>> get() async {
    UserDto? user = await AuthService.getAuthUser();
    var request = await Requests.get(url,
    headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
    );

    List<CategoriesDto>? toRet = [];

    if(request.statusCode == 200){
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(
          CategoriesDto.toObject(el)
        );
      }
    }

    return toRet;
  }
  
  @override
  Future save(CategoriesDto data) async {
    UserDto? user = await AuthService.getAuthUser();
    var request = await Requests.post(url,
    json: data.toMap(),
    headers: {'Authorization' :  " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
    );

    CategoriesDto? cat;

    if(request.statusCode == 201){
      cat = CategoriesDto.toObject(jsonDecode(request.body));
    }

    return cat;
  }
  Future update(CategoriesDto data) async {
      UserDto? user = await AuthService.getAuthUser();
      var request = await Requests.put(url,
      json: data.toMap(),
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json',},
      );

      if(request.statusCode == 200){
        dynamic data = jsonDecode(request.body);
        if(data['error'] != null){
          return data;
        }
        return CategoriesDto.toObject(data);
      }else{
        var dt = jsonDecode(request.body);
        return dt;
      }
  }

  @override
  Future delete(CategoriesDto data) async {
      UserDto? user = await AuthService.getAuthUser();
      var request = await Requests.delete("${url}/${data.id}",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
      );

      if(request.statusCode == 200){
        return true;
      }else{
        dynamic ret = request.body;
        return ret;
      }
  }
}