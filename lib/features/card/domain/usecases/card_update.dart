import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/domain/repositories/card_repository.dart';

class CardUpdate implements UseCases
{
  final CardRepository _repository;
  CardUpdate(CardRepository repository) : _repository=repository;

  @override
  Future<void> call({Card? dto}) async{
    await _repository.delete(dto!);
    return;
  }
  
}