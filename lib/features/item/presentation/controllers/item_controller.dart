import 'dart:developer';

import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/usecases/item_delete.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_expense.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_income.dart';
import 'package:drahkma/features/item/domain/usecases/item_save.dart';
import 'package:drahkma/features/item/domain/usecases/item_update.dart';
import 'package:flutter/material.dart';

class ItemController extends ValueNotifier<AppState> {
  final ItemGetIncome _getIncome;
  final ItemGetExpense _getExpense;
  final ItemDelete _delete;
  final ItemUpdate _update;
  final ItemSave _save;

  List<ItemModel>? data;

  ItemController(this._getIncome, this._getExpense, this._delete, this._update, this._save)
      : super(ItemInitial());

  Future<void> loadIncome({DateTime? start, DateTime? end}) async {
    value = ItemLoading();
    try {
      data = await _getIncome.call(start: start, end: end);
      value = ItemLoaded();
    } catch (e, s) {
      log(e.toString(), name: "Load Income", stackTrace: s);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> loadExpense({DateTime? start, DateTime? end}) async {
    value = ItemLoading();
    try {
      data = await _getExpense.call(start: start, end: end);
      value = ItemLoaded();
    } catch (e,s) {
      log(e.toString(), name: "Load Expense", stackTrace: s);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> deleteItem(ItemModel item) async {
    try {
      await _delete.call(item: item);
    } catch (e, s) {
      log(e.toString(), name: "Delete Item", error: item, stackTrace: s);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> saveItem(ItemDTO item) async {
    try {
      // The save method is not implemented yet, but it can be added in the future
      await _save.call(item: item);
      value = ItemSaved();
    } catch (e, s) {
      log(e.toString(), name: "Save Item", error: item, stackTrace: s);
      value = AppStateError(message: e.toString());
    }
  }

  Future<void> updateItem(ItemDTO item) async {
    try{
      await _update.call(item: item);
      value = ItemSaved();
    }
    catch(e, s) {
      log(e.toString(), name: "Update Item", error: item, stackTrace: s);
      value = AppStateError(message: e.toString());
    }
  }
}

class ItemInitial extends AppState {}
class ItemLoading extends AppState {}
class ItemLoaded extends AppState {}
class ItemSaved extends AppState {}
