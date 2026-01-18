import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/cards/domain/entities/cards.dart';
import 'package:drahkma/features/cards/domain/repositories/cards_repository.dart';

class CardsDelete implements UseCases
{
  final CardsRepository _repository;
  CardsDelete(CardsRepository repository): _repository=repository;

  @override
  Future<void> call({Cards? dto}) async
  {
    await _repository.delete(dto!);
  }
}