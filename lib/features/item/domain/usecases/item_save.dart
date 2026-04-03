import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';

class ItemSave implements UseCases<ItemModel>
{
  final ItemRepository _repository;
  ItemSave(ItemRepository repository):_repository=repository;
  @override
  Future<ItemModel?> call({ItemDTO? item}) async {
    return await _repository.save(item!);
  }
}