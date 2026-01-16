import 'package:drahkma/features/amounts/data/datasources/remote/amount_remote_datasource.dart';
import 'package:drahkma/features/amounts/data/models/dashboard_model.dart';
import 'package:drahkma/features/amounts/domain/entities/dashboard.dart';
import 'package:drahkma/features/amounts/domain/repositories/amounts_repository.dart';

class AmountsRepositoryImpl implements AmountsRepository
{
  final AmountRemoteDatasource _datasource;
  AmountsRepositoryImpl(AmountRemoteDatasource datasource): _datasource = datasource;

  @override
  Future<Dashboard?> fetchData({required DateTime startDate, required DateTime endDate}) async {
    Map<String, dynamic>? data = await _datasource.fetchAmounts(startDate, endDate);
    return DashboardModel.fromJson(data!);
  }
  
}