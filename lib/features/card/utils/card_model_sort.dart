import 'package:drahkma/features/card/data/models/card_model.dart';

class CardModelSort{
  static Comparator<CardModel> asc = (CardModel it1, CardModel it2) =>  it1.brand!.compareTo(it2.brand.toString());

  static Comparator<CardModel> desc = (CardModel it1, CardModel it2) => it2.brand!.compareTo(it1.brand.toString());
}