import 'package:drahkma/features/amounts/data/datasources/amount_remote_service.dart';
import 'package:drahkma/features/amounts/data/models/dashboard_model.dart';
import 'package:flutter/material.dart';


class _DataNotifier with ChangeNotifier {
  DashboardModel _data = DashboardModel();
  DashboardModel get data => _data;

  _DataNotifier();

  void _setData(DashboardModel value){
    _data = value;
    notifyListeners();
  }

  void getData(DateTimeRange dateRange) {

    AmountRemoteDatasource().getAmounts(dateRange.start, dateRange.end).then((DashboardModel? onValue) {
        _setData(onValue ?? DashboardModel());
    });
  }

}

var dataNotifier = _DataNotifier();