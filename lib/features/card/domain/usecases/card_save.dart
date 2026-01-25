import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/repositories/card_repository.dart';

class CardSave implements UseCases<Card>{
  
  final CardRepository _repository;
  CardSave(CardRepository repository) : _repository = repository;
  @override
  Future<Card?> call({Card? dto}) async {
    Card? data = await _repository.save(dto!);
    return data;
  }

}