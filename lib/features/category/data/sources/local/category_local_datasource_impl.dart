import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/category/data/mappers/category_mapper.dart';
import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';
import 'package:drahkma/features/category/data/sources/local/category_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  final SharedPreferencesAsync storage;

  CategoryLocalDatasourceImpl({required this.storage});

  @override
  Future<void> saveCategories(List<Category> categories) async {
    List<Map<String, dynamic>> dtoList = categories
        .map((category) => CategoryDTO.fromModel(CategoryMapper.toModel(category)).toMap())
        .toList();
    await storage.setString(
        Config.keyStorageCategories,
        JsonEncoder().convert(dtoList));
  }

  @override
  Future<List<Category>?> getCategories() async {
    String? jsonString = await storage.getString(Config.keyStorageCategories);
    if (jsonString != null) {
      List<dynamic> jsonList = JsonDecoder().convert(jsonString);
      return jsonList
          .map((json) => CategoryModel.fromJson(json))
          .cast<Category>()
          .toList();
    }
    return [];
  }

  @override
  Future<void> clearCategories() async {
    await storage.remove(Config.keyStorageCategories);
  }
}
