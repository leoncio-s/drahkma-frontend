import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';

class ItemDelete implements UseCases<void>
{
  final ItemRepository _repository;
  ItemDelete(ItemRepository repository):_repository=repository;
  @override
  Future<void> call({ItemModel? item}) async {
    await _repository.delete(item!);
  }
}