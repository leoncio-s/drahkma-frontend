import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/item/data/models/item_dto.dart';
import 'package:drahkma/features/item/data/models/item_model.dart';
import 'package:drahkma/features/item/domain/entities/item.dart';
import 'package:drahkma/features/item/data/sources/local/item_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemLocalDatasourceImpl implements ItemLocalDatasource {
  final SharedPreferencesAsync storage;

  ItemLocalDatasourceImpl({required this.storage});

  @override
  Future<void> saveItems(List<Item> items) async {
    List<Map<String, dynamic>> dtoList = items
        .map((item) => ItemDTO.fromModel(item).toMap())
        .toList();
    await storage.setString(
        Config.keyStorageItems,
        JsonEncoder().convert(dtoList));
  }

  @override
  Future<List<Item>?> getItems() async {
    String? jsonString = await storage.getString(Config.keyStorageItems);
    if (jsonString != null) {
      List<dynamic> jsonList = JsonDecoder().convert(jsonString);
      return jsonList
          .map((json) {
              return ItemModel.fromJson(json).toEntity();
          })
          // .cast<Item>()
          .toList();
    }
    return null;
  }

  @override
  Future<void> clearItems() async {
    await storage.remove(Config.keyStorageItems);
  }
}
