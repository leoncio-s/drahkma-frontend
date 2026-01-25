import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';

class ItemGetExpense implements UseCases<List<ItemModel>?>
{
  final ItemRepository _repository;
  ItemGetExpense(ItemRepository repository):_repository=repository;
  @override
  Future<List<ItemModel>?> call({DateTime? start, DateTime? end}) async {
    return await _repository.getExpense(start!, end!);
  }
}