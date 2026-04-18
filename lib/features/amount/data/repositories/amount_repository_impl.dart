import 'dart:developer';

import 'package:drahkma/features/amount/data/sources/remote/amount_remote_datasource.dart';
import 'package:drahkma/features/amount/data/sources/local/amount_local_datasource.dart';
import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';
import 'package:drahkma/features/amount/domain/repositories/amount_repository.dart';

class AmountRepositoryImpl implements AmountRepository
{
  final AmountRemoteDatasource _remoteDatasource;
  final AmountLocalDatasource _localDatasource;
  
  AmountRepositoryImpl(AmountRemoteDatasource remoteDatasource, AmountLocalDatasource localDatasource)
    : _remoteDatasource = remoteDatasource,
      _localDatasource = localDatasource;

  @override
  Future<Dashboard?> fetchData({required DateTime startDate, required DateTime endDate}) async {
    try {
      Map<String, dynamic>? data = await _remoteDatasource.fetchAmounts(startDate, endDate);
      if (data == null) return null;
      
      DashboardModel? dashboard = DashboardModel.fromJson(data);
      await _localDatasource.saveDashboard(dashboard);
      return dashboard;
    } catch (e, s) {
      log(e.toString(), name: "Repo Fetch Amounts", stackTrace: s);
      // Fallback to local datasource on network error
      return await _localDatasource.getDashboard();
    }
  }
  
}