import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/cards/domain/entities/cards.dart';
import 'package:drahkma/features/cards/domain/repositories/cards_repository.dart';

class CardsGetAll implements UseCases<List<Cards>?>
{
  final CardsRepository _repository;
  CardsGetAll(CardsRepository repository) : _repository = repository;
  
  @override
  Future<List<Cards>?> call() async {
    List<Cards>? data = await _repository.getAll();
    return data;
  }
}