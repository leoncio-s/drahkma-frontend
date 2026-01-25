import 'package:drahkma/features/card/data/models/card_dto.dart';
import 'package:drahkma/features/card/data/models/card_model.dart';

abstract interface class CardRemoteDatasource
{
  Future<CardModel?> save(CardDTO card);
  Future<void> update(CardDTO card);
  Future<CardModel?> getBy({int? id});
  Future<List<CardModel>?> getAll();
  Future<void> delete(CardModel card);
}