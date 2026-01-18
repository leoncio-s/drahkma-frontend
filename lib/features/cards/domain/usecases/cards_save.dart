import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/cards/domain/entities/cards.dart';
import 'package:drahkma/features/cards/domain/repositories/cards_repository.dart';

class CardsSave implements UseCases<Cards>{
  
  final CardsRepository _repository;
  CardsSave(CardsRepository repository) : _repository = repository;
  @override
  Future<Cards?> call({Cards? dto}) async {
    Cards? data = await _repository.save(dto!);
    return data;
  }

}