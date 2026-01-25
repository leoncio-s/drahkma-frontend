import 'package:drahkma/features/cards/data/models/cards_dto.dart';
import 'package:drahkma/features/cards/data/models/cards_model.dart';

abstract interface class CardsRemoteDatasource
{
  Future<CardsModel?> save(CardsDTO card);
  Future<void> update(CardsDTO card);
  Future<CardsModel?> getBy({int? id});
  Future<List<CardsModel>?> getAll();
  Future<void> delete(CardsModel card);
}