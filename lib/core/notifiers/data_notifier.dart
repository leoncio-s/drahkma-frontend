import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';
import 'package:drahkma/features/amount/domain/repositories/amount_repository.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/di/injector.dart';


class _DataNotifier with ChangeNotifier {
  DashboardModel _data = DashboardModel();
  DashboardModel get data => _data;

  _DataNotifier();

  void _setData(DashboardModel value){
    _data = value;
    notifyListeners();
  }

  void getData(DateTimeRange dateRange) {

    getIt<AmountRepository>().fetchData(
      startDate: dateRange.start,
      endDate: dateRange.end).then((Dashboard? onValue) {
        _setData(onValue as DashboardModel);
    });
  }

}

var dataNotifier = _DataNotifier();