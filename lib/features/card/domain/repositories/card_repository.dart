import 'package:drahkma/features/card/domain/entities/card.dart';

abstract interface class CardRepository
{
  Future<Card?> save(Card card);
  Future<void> update(Card card);
  Future<Card?> getBy({int? id});
  Future<List<Card>?> getAll();
  Future<void> delete(Card card);
}