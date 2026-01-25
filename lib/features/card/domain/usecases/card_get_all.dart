import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/repositories/card_repository.dart';

class CardGetAll implements UseCases<List<Card>?>
{
  final CardRepository _repository;
  CardGetAll(CardRepository repository) : _repository = repository;
  
  @override
  Future<List<Card>?> call() async {
    List<Card>? data = await _repository.getAll();
    return data;
  }
}