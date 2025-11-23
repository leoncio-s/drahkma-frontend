import 'dart:core';

import 'package:drahkma/features/items/data/models/item_model.dart';


class ItemModelSort{
  static Comparator<ItemModel>  dateDesc = (ItemModel it1, ItemModel it2) => it2.date!.compareTo(it1.date!);
  static Comparator<ItemModel>  dateAsc = (ItemModel it1, ItemModel it2) => it1.date!.compareTo(it2.date!);

  static Comparator<ItemModel>  descrDesc = (ItemModel it1, ItemModel it2) => it2.description!.toUpperCase().compareTo(it1.description!.toUpperCase());
  static Comparator<ItemModel>  descrAsc = (ItemModel it1, ItemModel it2) => it1.description!.toUpperCase().compareTo(it2.description!.toUpperCase());

  static Comparator<ItemModel>  valueDesc = (ItemModel it1, ItemModel it2) => it2.value!.compareTo(it1.value!);
  static Comparator<ItemModel>  valueAsc = (ItemModel it1, ItemModel it2) => it1.value!.compareTo(it2.value!);
}