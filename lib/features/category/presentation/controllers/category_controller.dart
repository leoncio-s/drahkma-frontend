import 'dart:developer';

import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/usecases/category_delete.dart';
import 'package:drahkma/features/category/domain/usecases/category_get_all.dart';
import 'package:drahkma/features/category/domain/usecases/category_save.dart';
import 'package:drahkma/features/category/domain/usecases/category_update.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CategoryController extends ValueNotifier<AppState> {
  final CategoryGetAll _getAll;
  final CategorySave _save;
  final CategoryUpdate _update;
  final CategoryDelete _delete;

  List<CategoryModel>? data;

  CategoryController(this._getAll, this._save, this._update, this._delete)
      : super(CategoryInitial());

  Future<void> loadCategories() async {
    value = CategoryLoading();
    try {
      data = await _getAll.call();
      value = CategoryLoaded();
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Load Category");
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> saveCategory(CategoryDTO category) async {
    try {
      await _save.call(category: category);
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Save Category", error: category);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> updateCategory(CategoryDTO category) async {
    try {
      await _update.call(category: category);
    } catch (e, s) {
      log(e.toString(), stackTrace: s, name: "Update Category", error: category);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> deleteCategory(CategoryModel category) async {
    try {
      await _delete.call(category: category);
    } on ClientException catch (e) {
      value = AppStateError(message: e.message);
    }catch(e, s)
    {
      log(e.toString(), stackTrace: s, name: "Delete Category", error: category);
      value = AppStateError(message: e.toString());
    }
  }
}

class CategoryInitial extends AppState {}
class CategoryLoading extends AppState {}
class CategoryLoaded extends AppState {}
class CategorySaved extends AppState {}
