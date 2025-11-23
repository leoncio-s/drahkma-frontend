import 'dart:convert';

import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/categories/data/models/category_model.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:requests/requests.dart';

class CategoriesRemoteDatasource implements Services<CategoryModel>{

  
  final String url = "${Config.urlApi}categories";

  @override
  Future<List<CategoryModel>> get() async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var request = await Requests.get(url,
    headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
    );

    List<CategoryModel>? toRet = [];

    if(request.statusCode == 200){
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(
          CategoryModel.toObject(el)
        );
      }
    }

    return toRet;
  }
  
  @override
  Future save(CategoryModel data) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    var request = await Requests.post(url,
    json: data.toMap(),
    headers: {'Authorization' :  " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json'},
    );

    CategoryModel? cat;

    if(request.statusCode == 201){
      cat = CategoryModel.toObject(jsonDecode(request.body));
    }

    return cat;
  }

  @override
  Future update(CategoryModel data) async {
      UserModel? user = await AuthRemoteDatasource.getAuthUser();
      var request = await Requests.put(url,
      json: data.toMap(),
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}", 'Content-type': 'application/json',},
      );

      if(request.statusCode == 200){
        dynamic data = jsonDecode(request.body);
        if(data['error'] != null){
          return data;
        }
        return CategoryModel.toObject(data);
      }else{
        var dt = jsonDecode(request.body);
        return dt;
      }
  }

  @override
  Future delete(CategoryModel data) async {
      UserModel? user = await AuthRemoteDatasource.getAuthUser();
      var request = await Requests.delete("$url/${data.id}",
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