import 'package:drahkma/Auth/auth_service.dart';
import 'package:drahkma/Interfaces/services.dart';
import 'package:drahkma/Items/ItemDto.dart';
import 'package:drahkma/User/user_dto.dart';
import 'package:drahkma/config.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:requests/requests.dart';

class ItemsService extends Services<ItemDto> {

  final String? url = "${Config.urlApi}item";

  Future<List<ItemDto>?> getInflow(DateTime start, DateTime finish) async {
    UserDto? user = await AuthService.getAuthUser();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    Response response = await Requests.get(
      "$url/inflow",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
      queryParameters: {
      'start_date' : dateFormat.format(start),
      'finish_date': dateFormat.format(finish)
    });
    List<ItemDto>? ret = [];

    if(response.statusCode == 200){
      List<dynamic> data = response.json();
      // debugPrint(data.toString());
      for (var el in data) {
        ret.add(ItemDto.toObject(el));
      }
      return ret;
    }
    return response.json();
  }

  Future<List<ItemDto>?> getOutflow(DateTime start, DateTime finish) async {
    UserDto? user = await AuthService.getAuthUser();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    Response response = await Requests.get(
      "$url/outflow",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"},
      queryParameters: {
      'start_date' : dateFormat.format(start),
      'finish_date': dateFormat.format(finish)
    });
    List<ItemDto>? ret = [];


    if(response.statusCode == 200){
      List<dynamic> data = response.json();
      // debugPrint(data.toString());
      for (var el in data) {
        ret.add(ItemDto.toObject(el));
      }
      return ret;
    }
    return response.json();
  }
  
  @override
  Future delete(ItemDto item) async {
      UserDto? user = await AuthService.getAuthUser();
      Response response = await Requests.delete(
      "$url/${item.id}",
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"});

      if(response.success){
        return true;
      }else{
        return response.json();
      }
  }
  
  @override
  Future get() {
    // TODO: implement get
    throw UnimplementedError();
  }
  
  @override
  Future save(ItemDto data) async {
    UserDto? user = await AuthService.getAuthUser();
      Response response = await Requests.post(
      "$url",
      json: data.toMap(),
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"});
    
    if(response.statusCode == 201){
      return ItemDto.toObject(response.json());
    }else if(response.body.isNotEmpty){
      return response.json();
    }
    return null;
  }
  
  @override
  Future update(ItemDto data) async{
    UserDto? user = await AuthService.getAuthUser();
      Response response = await Requests.put(
      "$url",
      json: data.toMap(),
      headers: {'Authorization' :  " Bearer ${user?.token ?? ''}"});
  
    if(response.statusCode == 200){
      return ItemDto.toObject(response.json());
    }else if(response.body.isNotEmpty){
      return response.json();
    }
    return null;
  }
}