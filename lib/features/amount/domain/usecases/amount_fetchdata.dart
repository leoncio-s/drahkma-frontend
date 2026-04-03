import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/amount/domain/entities/dashboard.dart';
import 'package:drahkma/features/amount/domain/repositories/amount_repository.dart';

class AmountsFetchdata implements UseCases<Dashboard>
{
  final AmountRepository _repository;
  final now = DateTime.now();
  AmountsFetchdata(AmountRepository repository) : _repository = repository;
  
  @override
  Future<Dashboard?> call([
    DateTime? start, DateTime? end]) async {
    final DateTime now = DateTime.now();
    start = start ?? DateTime(now.year, now.month, 1);
    end = end ?? DateTime(now.year, now.month, -1);
    Dashboard? data = await _repository.fetchData(
      startDate: start, 
      endDate: end);
    return data;
  }
  
}