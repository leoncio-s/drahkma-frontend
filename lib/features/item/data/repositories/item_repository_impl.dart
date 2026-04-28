import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/data/mappers/item_mapper.dart';
import 'package:drahkma/features/item/data/sources/remote/item_remote_datasource.dart';
import 'package:drahkma/features/item/data/sources/local/item_local_datasource.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/item/domain/repositories/item_repository.dart';

class ItemRepositoryImpl implements ItemRepository
{
  final ItemRemoteDatasource _remoteDatasource;
  final ItemLocalDatasource _localDatasource;
  
  ItemRepositoryImpl(ItemRemoteDatasource remoteDatasource, ItemLocalDatasource localDatasource)
    : _remoteDatasource = remoteDatasource,
      _localDatasource = localDatasource;

  @override
  Future<void> delete(Item item) async {
    try {
      await _remoteDatasource.delete(item);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ItemModel>?> getExpense(DateTime start, DateTime end) async {
    try {
      List<ItemModel>? items = await _remoteDatasource.getExpense(start, end);
      if (items != null) {
        await _localDatasource.saveItems(items.map((item) => ItemMapper.toEntity(item)).toList());
      }
      return items;
    } catch (e) {
      // Fallback to local datasource on network error
      List<Item>? localItems = await _localDatasource.getItems();
      return localItems?.map((item) => ItemMapper.toModel(item)).toList();
    }
  }

  @override
  Future<List<ItemModel>?> getIncome(DateTime start, DateTime end) async {
    try {
      List<ItemModel>? items = await _remoteDatasource.getIncome(start, end);
      if (items != null) {
        await _localDatasource.saveItems(items.map((item) => ItemMapper.toEntity(item)).toList());
      }
      return items;
    } catch (e) {
      // Fallback to local datasource on network error
      List<Item>? localItems = await _localDatasource.getItems();
      return localItems?.map((item) => ItemMapper.toModel(item)).toList();
    }
  }

  @override
  Future<ItemModel?> save(ItemDTO item) async {
    try {
      ItemModel? savedItem = await _remoteDatasource.save(item);
      if (savedItem != null) {
        await _localDatasource.saveItems([ItemMapper.toEntity(savedItem)]);
      }
      return savedItem;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> update(ItemDTO item) async {
    try {
      await _remoteDatasource.update(item);
      await _localDatasource.saveItems([ItemMapper.fromDTOToEntity(item)]);
    } catch (e) {
      await _localDatasource.saveItems([ItemMapper.fromDTOToEntity(item)]);
      rethrow;
    }
  }
  
}