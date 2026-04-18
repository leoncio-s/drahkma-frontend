import 'package:drahkma/features/amount/domain/entities/dashboard.dart';

abstract interface class AmountLocalDatasource {
  Future<void> saveDashboard(Dashboard dashboard);
  Future<Dashboard?> getDashboard();
  Future<void> clearDashboard();
}
