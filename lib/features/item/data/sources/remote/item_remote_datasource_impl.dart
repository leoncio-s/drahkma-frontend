import 'dart:convert';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/error/unauthenticated_exception.dart';
import 'package:drahkma/core/utils/helpers/join_url.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/sources/local/auth_local_datasource.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/data/sources/remote/item_remote_datasource.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ItemRemoteDatasourceImpl implements ItemRemoteDatasource
{
  static final Uri _url = Uri.parse("${Config.urlApi}item");

  @override
  Future<List<ItemModel>?> getIncome(DateTime start, DateTime end) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    if (user == null) throw UnauthenticatedException();

    DateFormat dateFormat = DateFormat("yyyyMMdd");
    var url = joinUrl(_url, 'inflow');
    Response response = await http.get(
      url.replace(queryParameters: {
        'start_date': dateFormat.format(start),
        'finish_date': dateFormat.format(end)
      }),
      headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"},
    );
    List<ItemModel>? ret = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var el in data) {
        ret.add(ItemModel.fromJson(el));
      }
      return ret;
    }else if(response.statusCode == 401)
    {
      throw UnauthenticatedException();
    }else
    {
      throw ArgumentError(response.body, "Get income request");
    }
  }

  @override
  Future<List<ItemModel>?> getExpense(DateTime start, DateTime end) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    if (user == null) throw UnauthenticatedException();
    DateFormat dateFormat = DateFormat("yyyyMMdd");
    var url = joinUrl(_url, 'outflow');
    Response response = await http.get(
        url.replace(queryParameters: {
          'start_date': dateFormat.format(start),
          'finish_date': dateFormat.format(end)
        }),
        headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"});
    List<ItemModel>? ret = [];

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      for (var el in data) {
        ret.add(ItemModel.fromJson(el));
      }
      return ret;
    }else if(response.statusCode == 401)
    {
      throw UnauthenticatedException();
    }else
    {
      throw ArgumentError(response.body, "Get expense request");
    }
  }

  @override
  Future delete(Item item) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    if (user == null) throw UnauthenticatedException();
    var url = joinUrl(_url, item.id.toString());
    Response response = await http.delete(url,
        headers: {'Authorization': " Bearer ${userModel?.token ?? ''}"});

    if (response.statusCode == 200) {
      return;
    }else if(response.statusCode == 401)
    {
      throw UnauthenticatedException();
    }else
    {
      throw ArgumentError(response.body, "delete item request");
    }
  }

  @override
  Future<ItemModel?> save(ItemDTO item) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    if (user == null) throw UnauthenticatedException();
    Response response = await http.post(_url,
        body: jsonEncode(item.toMap()),
        headers: {'Authorization': " Bearer ${userModel?.token ?? ''}", "Content-type":"application/json"});

    late Map json;
    if (response.statusCode == 201) {
      json = jsonDecode(response.body);
      return ItemModel.fromJson(json);
    }else if(response.statusCode == 401)
    {
      throw UnauthenticatedException();
    }else
    {
      throw ArgumentError(response.body, "Save item request");
    }
  }

  @override
  Future<void> update(ItemDTO item) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    UserModel? userModel = user as UserModel?;
    if (user == null) throw UnauthenticatedException();
    Response response = await http.put(_url,
        body: jsonEncode(item.toMap()),
        headers: {'Authorization': " Bearer ${userModel?.token ?? ''}", "Content-type":"application/json"});

    if (response.statusCode == 200) {
      return;
    } else if(response.statusCode == 401)
    {
      throw UnauthenticatedException();
    }else
    {
      throw ArgumentError(response.body, "update item request");
    }
  }
}
