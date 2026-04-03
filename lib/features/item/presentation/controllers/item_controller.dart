import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/item/domain/usecases/item_delete.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_expense.dart';
import 'package:drahkma/features/item/domain/usecases/item_get_income.dart';
import 'package:flutter/material.dart';

class ItemController extends ValueNotifier<AppState> {
  final ItemGetIncome _getIncome;
  final ItemGetExpense _getExpense;
  final ItemDelete _delete;

  ItemController(this._getIncome, this._getExpense, this._delete)
      : super(ItemInitial());

  Future<void> loadIncome({DateTime? start, DateTime? end}) async {
    value = ItemLoading();
    try {
      await _getIncome.call(start: start, end: end);
      value = ItemLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> loadExpense({DateTime? start, DateTime? end}) async {
    value = ItemLoading();
    try {
      await _getExpense.call(start: start, end: end);
      value = ItemLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }

  Future<void> deleteItem(int itemId) async {
    try {
      await _delete.call(id: itemId);
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }
}

class ItemInitial extends AppState {}
class ItemLoading extends AppState {}
class ItemLoaded extends AppState {}
