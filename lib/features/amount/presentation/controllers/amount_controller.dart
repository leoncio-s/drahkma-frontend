import 'dart:developer';

import 'package:drahkma/core/presentation/controllers/app_state.dart';
import 'package:drahkma/features/amount/data/mappers/dashboard_mapper.dart';
import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/usecases/amount_fetchdata.dart';
import 'package:flutter/material.dart';

class AmountController extends ValueNotifier<AppState> {
  final AmountsFetchdata _fetchData;
  DashboardModel? _data = DashboardModel();

  DashboardModel? get data => _data;

  AmountController(this._fetchData) : super(AmountsInitial());

  Future<void> loadAmounts({DateTime? start, DateTime? end}) async {
    value = AmountsLoading();
    try {
      var ret = await _fetchData.call(start, end);
      _data = DashboardMapper.entityToModel(ret!);
      value = AmountsLoaded();
    } catch (e, s) {
      log(e.toString(), name: "Load Amounts", stackTrace: s);
      value = AppStateError(message: e.toString());
    }
  }
}

class AmountsInitial extends AppState {}
class AmountsLoading extends AppState {}
class AmountsLoaded extends AppState {}
