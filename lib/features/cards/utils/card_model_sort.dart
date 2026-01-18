import 'package:drahkma/features/cards/data/models/cards_model.dart';

class CardModelSort{
  static Comparator<CardsModel> asc = (CardsModel it1, CardsModel it2) =>  it1.brand!.compareTo(it2.brand.toString());

  static Comparator<CardsModel> desc = (CardsModel it1, CardsModel it2) => it2.brand!.compareTo(it1.brand.toString());
}