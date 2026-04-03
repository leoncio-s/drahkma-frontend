import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:flutter/material.dart';

abstract interface class DataNotifierInterface with ChangeNotifier
{
  DashboardModel get data;
  Future<void> fetchData(DateTimeRange dateRange);
}