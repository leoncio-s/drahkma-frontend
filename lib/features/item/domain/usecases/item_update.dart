import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';

class ItemUpdate implements UseCases<void>
{
  final ItemRepository _repository;
  ItemUpdate(ItemRepository repository):_repository=repository;
  @override
  Future<void> call({ItemDTO? item}) async {
    await _repository.update(item!);
  }
}