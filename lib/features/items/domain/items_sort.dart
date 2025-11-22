import 'dart:core';

import 'package:drahkma/features/items/data/models/item.dart';


class ItemsSorts{
  static Comparator<Item>  dateDesc = (Item it1, Item it2) => it2.date!.compareTo(it1.date!);
  static Comparator<Item>  dateAsc = (Item it1, Item it2) => it1.date!.compareTo(it2.date!);

  static Comparator<Item>  descrDesc = (Item it1, Item it2) => it2.description!.toUpperCase().compareTo(it1.description!.toUpperCase());
  static Comparator<Item>  descrAsc = (Item it1, Item it2) => it1.description!.toUpperCase().compareTo(it2.description!.toUpperCase());

  static Comparator<Item>  valueDesc = (Item it1, Item it2) => it2.value!.compareTo(it1.value!);
  static Comparator<Item>  valueAsc = (Item it1, Item it2) => it1.value!.compareTo(it2.value!);
}