import 'package:flutter/material.dart';
import 'package:drahkma/dashboard/dash_services.dart';
import 'package:drahkma/dashboard/dashboard_dto.dart';

class _DataNotifier with ChangeNotifier {
  DashboardDto _data = DashboardDto();
  DashboardDto get data => _data;

  _DataNotifier();

  void _setData(DashboardDto value){
    _data = value;
    notifyListeners();
  }

  getData(DateTimeRange dateRange) {

    DashServices().getAmounts(dateRange.start, dateRange.end).then((DashboardDto? onValue) {
        _setData(onValue ?? DashboardDto());
    });
  }

}

// ignore: library_private_types_in_public_api
_DataNotifier dataNotifier = _DataNotifier();