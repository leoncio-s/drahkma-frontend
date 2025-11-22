import 'package:drahkma/features/amounts/data/datasources/amount_remote_service.dart';
import 'package:drahkma/features/amounts/data/models/dashboard.dart';
import 'package:flutter/material.dart';


class _DataNotifier with ChangeNotifier {
  Dashboard _data = Dashboard();
  Dashboard get data => _data;

  _DataNotifier();

  void _setData(Dashboard value){
    _data = value;
    notifyListeners();
  }

  void getData(DateTimeRange dateRange) {

    AmountRemoteDatasource().getAmounts(dateRange.start, dateRange.end).then((Dashboard? onValue) {
        _setData(onValue ?? Dashboard());
    });
  }

}

var dataNotifier = _DataNotifier();