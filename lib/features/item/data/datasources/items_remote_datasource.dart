
import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/items/data/models/item_model.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:requests/requests.dart';
import 'package:drahkma/features/auth/data/datasources/auth_remote_datasource.dart';

class ItemsRemoteDatasource extends Services<ItemModel> {

  final String? url = "${Config.urlApi}item";

  Future<List<ItemModel>?> getInflow(DateTime start, DateTime finish) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    Response response = await Requests.get(
      "$url/inflow",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
      queryParameters: {
      'start_date' : dateFormat.format(start),
      'finish_date': dateFormat.format(finish)
    });
    List<ItemModel>? ret = [];

    if(response.statusCode == 200){
      List<dynamic> data = response.json();
      for (var el in data) {
        ret.add(ItemModel.toObject(el));
      }
      return ret;
    }
    return response.json();
  }

  Future<List<ItemModel>?> getOutflow(DateTime start, DateTime finish) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    Response response = await Requests.get(
      "$url/outflow",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
      queryParameters: {
      'start_date' : dateFormat.format(start),
      'finish_date': dateFormat.format(finish)
    });
    List<ItemModel>? ret = [];


    if(response.statusCode == 200){
      List<dynamic> data = response.json();
      // debugPrint(data.toString());
      for (var el in data) {
        ret.add(ItemModel.toObject(el));
      }
      return ret;
    }
    return response.json();
  }
  
  @override
  Future delete(ItemModel data) async {
      UserModel? user = await AuthRemoteDatasource.getAuthUser();
      Response response = await Requests.delete(
      "$url/${data.id}",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"});

      if(response.success){
        return true;
      }else{
        return response.json();
      }
  }
  
  @override
  Future get() {
    throw UnimplementedError();
  }
  
  @override
  Future save(ItemModel data) async {
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
      Response response = await Requests.post(
      "$url",
      json: data.toMap(),
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"});
    
    if(response.statusCode == 201){
      return ItemModel.toObject(response.json());
    }else if(response.body.isNotEmpty){
      return response.json();
    }
    return null;
  }
  
  @override
  Future update(ItemModel data) async{
    UserModel? user = await AuthRemoteDatasource.getAuthUser();
      Response response = await Requests.put(
      "$url",
      json: data.toMap(),
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"});
  
    if(response.statusCode == 200){
      return ItemModel.toObject(response.json());
    }else if(response.body.isNotEmpty){
      return response.json();
    }
    return null;
  }
}