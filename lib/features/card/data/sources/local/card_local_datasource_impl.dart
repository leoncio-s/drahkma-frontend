import 'dart:convert';

import 'package:drahkma/core/config.dart';
import 'package:drahkma/features/card/data/mappers/card_mapper.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';
import 'package:drahkma/features/card/domain/entities/card.dart';
import 'package:drahkma/features/card/data/sources/local/card_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardLocalDatasourceImpl implements CardLocalDatasource {
  final SharedPreferencesAsync storage;

  CardLocalDatasourceImpl({required this.storage});

  @override
  Future<void> saveCards(List<Card> cards) async {
    List<Map<String, dynamic>> dtoList = cards
        .map((card) => CardMapper.fromEntityToDTO(card).toMap())
        .toList();
    await storage.setString(
        Config.keyStorageCards,
        JsonEncoder().convert(dtoList));
  }

  @override
  Future<List<Card>?> getCards() async {
    String? jsonString = await storage.getString(Config.keyStorageCards);
    if (jsonString != null) {
      List<dynamic> jsonList = JsonDecoder().convert(jsonString);
      return jsonList
          .map((json) => CardModel.fromJson(json))
          .cast<Card>()
          .toList();
    }
    return null;
  }

  @override
  Future<void> clearCards() async {
    await storage.remove(Config.keyStorageCards);
  }
}
