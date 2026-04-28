import 'dart:developer';

import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/data/mappers/category_mapper.dart';
import 'package:drahkma/features/category/data/sources/remote/category_remote_datasource.dart';
import 'package:drahkma/features/category/data/sources/local/category_local_datasource.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository
{
  final CategoryRemoteDatasource _remoteDatasource;
  final CategoryLocalDatasource _localDatasource;
  
  CategoryRepositoryImpl(CategoryRemoteDatasource remoteDatasource, CategoryLocalDatasource localDatasource)
    : _remoteDatasource = remoteDatasource,
      _localDatasource = localDatasource;

  @override
  Future<void> delete(CategoryModel data) async {
    try {
      await _remoteDatasource.delete(data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>?> getAll() async {
    try {
      List<CategoryModel>? categories = await _remoteDatasource.getAll();
      if (categories != null) {
        List<Category> entitiesToCache = categories.map((m) => CategoryMapper.toEntity(m)).toList();
        await _localDatasource.saveCategories(entitiesToCache);
      }
      return categories;
    } catch (e) {
      var cached = await _localDatasource.getCategories();
      if (cached != null) {
        return cached.map((c) => CategoryMapper.toModel(c)).cast<CategoryModel>().toList();
      }
      return null;
    }
  }

  @override
  Future<List<CategoryModel>?> getAllByUser() async {
    try {
      List<CategoryModel>? categories = await _remoteDatasource.getAllByUser();
      if (categories != null) {
        List<Category> entitiesToCache = categories.map((m) => CategoryMapper.toEntity(m)).toList();
        await _localDatasource.saveCategories(entitiesToCache);
      }
      return categories;
    } catch (e) {
      log(e.toString());
      var cached = await _localDatasource.getCategories();
      if (cached != null) {
        return cached.map((c) => CategoryMapper.toModel(c)).cast<CategoryModel>().toList();
      }
      return [];
    }
  }

  @override
  Future<CategoryModel?> getBy({int? id}) async {
    return await _remoteDatasource.getBy(id: id);
  }

  @override
  Future<CategoryModel?> save(CategoryDTO data) async {
    try {
      CategoryModel? savedCategory = await _remoteDatasource.save(data);
      if (savedCategory != null) {
        await _localDatasource.saveCategories([CategoryMapper.toEntity(savedCategory)]);
      }
      return savedCategory;
    } catch (e) {
      var cached = await _localDatasource.getCategories();
      return cached?.isEmpty ?? true ? null : CategoryMapper.toModel(cached!.first);
    }
  }

  @override
  Future<void> update(CategoryDTO data) async {
    try {
      await _remoteDatasource.update(data);
      await _localDatasource.saveCategories([CategoryMapper.toEntity(CategoryModel.fromJson(data.toMap()))]);
    } catch (e) {
      await _localDatasource.saveCategories([CategoryMapper.toEntity(CategoryModel.fromJson(data.toMap()))]);
      rethrow;
    }
  }
  
}