import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/data/sources/item_remote_datasource.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository
{
  final ItemRemoteDatasource _datasource;
  ItemRepositoryImpl(ItemRemoteDatasource datasource):_datasource=datasource;

  @override
  Future<void> delete(Item item) async {
    await _datasource.delete(item);
  }


  @override
  Future<List<ItemModel>?> getExpense(DateTime start, DateTime end) async {
    return await _datasource.getExpense(start, end);
  }

  @override
  Future<List<ItemModel>?> getIncome(DateTime start, DateTime end) async {
    return await _datasource.getIncome(start, end);
  }

  @override
  Future<ItemModel?> save(ItemDTO item) async {
    return _datasource.save(item);
  }

  @override
  Future<void> update(ItemDTO item) async {
    await _datasource.update(item);
  }
  
}