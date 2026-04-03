import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/category/domain/usecases/category_delete.dart';
import 'package:drahkma/features/category/domain/usecases/category_get_all.dart';
import 'package:drahkma/features/category/domain/usecases/category_save.dart';
import 'package:drahkma/features/category/domain/usecases/category_update.dart';
import 'package:flutter/material.dart';

class CategoryController extends ValueNotifier<AppState> {
  final CategoryGetAll _getAll;
  final CategorySave _save;
  final CategoryUpdate _update;
  final CategoryDelete _delete;

  CategoryController(this._getAll, this._save, this._update, this._delete)
      : super(CategoryInitial());

  Future<void> loadCategories() async {
    value = CategoryLoading();
    try {
      await _getAll.call();
      value = CategoryLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> saveCategory(dynamic category) async {
    try {
      await _save.call(category: category);
      await loadCategories();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> updateCategory(dynamic category) async {
    try {
      await _update.call(category: category);
      await loadCategories();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      await _delete.call(id: categoryId);
      await loadCategories();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }
}

class CategoryInitial extends AppState {}
class CategoryLoading extends AppState {}
class CategoryLoaded extends AppState {}
