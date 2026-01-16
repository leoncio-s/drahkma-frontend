import 'package:drahkma/features/amounts/domain/entities/dashboard.dart';

abstract interface class AmountsRepository
{
  Future<Dashboard?> fetchData({required DateTime startDate, required DateTime endDate});
}