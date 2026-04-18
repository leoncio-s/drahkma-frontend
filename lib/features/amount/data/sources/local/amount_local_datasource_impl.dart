import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/amount/data/mappers/dashboard_mapper.dart';
import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';
import 'package:drahkma/features/amount/data/sources/local/amount_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AmountLocalDatasourceImpl implements AmountLocalDatasource {
  final SharedPreferencesAsync storage;

  AmountLocalDatasourceImpl({required this.storage});

  @override
  Future<void> saveDashboard(Dashboard dashboard) async {
    DashboardModel model = DashboardMapper.entityToModel(dashboard);
    await storage.setString(
        Config.keyStorageDashboard,
        JsonEncoder().convert(model.toMap()));
  }

  @override
  Future<Dashboard?> getDashboard() async {
    String? jsonString = await storage.getString(Config.keyStorageDashboard);
    if (jsonString != null) {
      var json = JsonDecoder().convert(jsonString);
      return DashboardModel.fromJson(json);
    }
    return DashboardModel();
  }

  @override
  Future<void> clearDashboard() async {
    await storage.remove(Config.keyStorageDashboard);
  }
}
