import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';

abstract interface class ItemRemoteDatasource
{
  Future<ItemModel?> save(ItemDTO item);
  Future<void>  update(ItemDTO item);
  Future<void>  delete(Item item);
  Future<List<ItemModel>?> getIncome(DateTime start, DateTime end);
  Future<List<ItemModel>?> getExpense(DateTime start, DateTime end);
}