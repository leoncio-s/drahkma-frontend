import 'package:drahkma/features/amount/domain/entities/dashboard.dart';

abstract interface class AmountRepository
{
  Future<Dashboard?> fetchData({required DateTime startDate, required DateTime endDate});
}