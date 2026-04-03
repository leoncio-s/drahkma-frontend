import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/amount/domain/usecases/amounts_fetch_data.dart';
import 'package:flutter/material.dart';

class AmountController extends ValueNotifier<AppState> {
  final AmountsFetchdata _fetchData;

  AmountController(this._fetchData) : super(AmountsInitial());

  Future<void> loadAmounts({DateTime? start, DateTime? end}) async {
    value = AmountsLoading();
    try {
      await _fetchData.call(start: start, end: end);
      value = AmountsLoaded();
    } catch (e) {
      value = ErrorState(message: e.toString());
    }
  }
}

class AmountsInitial extends AppState {}
class AmountsLoading extends AppState {}
class AmountsLoaded extends AppState {}
