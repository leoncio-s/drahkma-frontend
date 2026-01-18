import 'package:drahkma/features/cards/domain/entities/cards.dart';

abstract interface class CardsRepository
{
  Future<Cards?> save(Cards card);
  Future<void> update(Cards card);
  Future<Cards?> getBy({int? id});
  Future<List<Cards>?> getAll();
  Future<void> delete(Cards card);
}