import 'package:drahkma/core/presentation/notifiers/data_notifier_interface.dart';
import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';
import 'package:drahkma/features/amount/domain/repositories/amount_repository.dart';
import 'package:flutter/material.dart';
import 'package:drahkma/di/injector.dart';


class DataNotifier  with ChangeNotifier implements DataNotifierInterface {
  DashboardModel _data = DashboardModel();

  @override
  DashboardModel get data => _data;

  DataNotifier();

  // void _setData(DashboardModel value){
  //   _data = value;
  //   notifyListeners();
  // }

  @override
  Future<void> fetchData(DateTimeRange dateRange) async {

    Dashboard? data = await getIt<AmountRepository>().fetchData(
      startDate: dateRange.start,
      endDate: dateRange.end);
    _data = data as DashboardModel;
    notifyListeners();
  }

}

var dataNotifier = DataNotifier();