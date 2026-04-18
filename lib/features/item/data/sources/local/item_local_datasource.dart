import 'package:drahkma/features/item/domain/entities/item.dart';

abstract interface class ItemLocalDatasource {
  Future<void> saveItems(List<Item> items);
  Future<List<Item>?> getItems();
  Future<void> clearItems();
}
