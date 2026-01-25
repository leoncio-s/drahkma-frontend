import 'dart:convert';
import 'package:drahkma/core/config.dart';
import 'package:drahkma/core/exceptions/unauthenticated_exception.dart';
import 'package:drahkma/di/injector.dart';
import 'package:drahkma/features/auth/data/source/local/auth_local_datasource.dart';
import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/data/sources/category_remote_datasource.dart';
import 'package:drahkma/features/users/data/models/user_model.dart';
import 'package:drahkma/features/users/domain/entities/user.dart';
import 'package:http/http.dart' as http;

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource
{
  static final Uri _url = Uri.parse("${Config.urlApi}Category");

  @override
  Future<List<CategoryModel>> getAll() async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var request = await http.get(
      _url,
      headers: {'Authorization': " Bearer ${user?.token ?? ''}"},
    );

    List<CategoryModel>? toRet = [];

    if (request.statusCode == 200) {
      List<dynamic> data = jsonDecode(request.body);
      for (var el in data) {
        toRet.add(CategoryModel.fromJson(el));
      }
    }

    return toRet;
  }

  @override
  Future<CategoryModel?> save(CategoryDTO data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    var request = await http.post(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {
        'Authorization': " Bearer ${user?.token ?? ''}",
        'Content-type': 'application/json'
      },
    );

    CategoryModel? cat;

    if (request.statusCode == 201) {
      cat = CategoryModel.fromJson(jsonDecode(request.body));
    }

    return cat;
  }

  @override
  Future<void> update(CategoryDTO data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
    if (user == null) throw UnauthenticatedException();
    
    var request = await http.put(
      _url,
      body: jsonEncode(data.toMap()),
      headers: {
        'Authorization': " Bearer ${user.token ?? ''}",
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
  Future delete(CategoryModel data) async {
    User? user = await getIt<AuthLocalDatasource>().getAuthToken();
    user as UserModel?;
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
  Future<CategoryModel?> getBy({int? id}) {
    throw UnimplementedError();
  }
}
