import 'dart:convert';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/exceptions/unauthenticated_exception.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/categories/data/models/categories_dto.dart';
import 'package:drahkma/features/categories/data/models/categories_model.dart';
import 'package:drahkma/features/categories/data/sources/categories_remote_datasource.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class CategoriesRemoteDatasourceImpl implements CategoriesRemoteDatasource
{
  static final Uri _url = Uri.parse("${Config.urlApi}categories");

  @override
  Future<List<CategoriesModel>> getAll() async {
    UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<CategoriesModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(CategoriesModel.fromJson(el));
      }
    }

    return toRet;
  }

  @override
  Future<CategoriesModel?> save(CategoriesDTO data) async {
    UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
    var request = await http.post(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    CategoriesModel? cat;

    if (request.statusCode == 201) {
      cat = CategoriesModel.fromJson(jsonDecode(request.body));
    }

    return cat;
  }

  @override
  Future<void> update(CategoriesDTO data) async {
    UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
    if (user == null) throw UnauthenticatedException();
    
    var request = await http.put(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json',
      },
    );

    if (request.statusCode == 200) {
      dynamic data = jsonDecode(request.body);
      if (data['error'] != null) {
        throw http.ClientException(data['error']);
      }
      return;
    } else {
      throw Exception(request.body);
    }
  }

  @override
  Future delete(CategoriesModel data) async {
    UserModel? user = await getIt<AuthLocalDatasource>().getAuthToken();
    var request = await http.delete(
      _url.resolve("/${data.id}"),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    if (request.statusCode == 200) {
      return true;
    } else {
      dynamic ret = request.body;
      return ret;
    }
  }
  
  @override
  Future<CategoriesModel?> getBy({int? id}) {
    // TODO: implement getBy
    throw UnimplementedError();
  }
}
