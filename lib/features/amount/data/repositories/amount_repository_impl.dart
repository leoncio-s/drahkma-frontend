import 'package:drahkma/features/amount/data/datasources/remote/amount_remote_datasource.dart';
import 'package:drahkma/features/amount/data/models/dashboard_model.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';
import 'package:drahkma/features/amount/domain/repositories/amount_repository.dart';

class AmountRepositoryImpl implements AmountRepository
{
  final AmountRemoteDatasource _datasource;
  AmountRepositoryImpl(AmountRemoteDatasource datasource): _datasource = datasource;

  @override
  Future<Dashboard?> fetchData({required DateTime startDate, required DateTime endDate}) async {
    Map<String, dynamic>? data = await _datasource.fetchAmounts(startDate, endDate);
    return DashboardModel.fromJson(data!);
  }
  
}