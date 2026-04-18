import 'package:drahkma/features/card/domain/entities/card.dart';

abstract interface class CardLocalDatasource {
  Future<void> saveCards(List<Card> cards);
  Future<List<Card>?> getCards();
  Future<void> clearCards();
}
