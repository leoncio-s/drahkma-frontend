import 'dart:core';

import 'package:drahkma/Items/ItemDto.dart';


class ItemsSorts{
  static Comparator<ItemDto>  dateDesc = (ItemDto it1, ItemDto it2) => it2.date!.compareTo(it1.date!);
  static Comparator<ItemDto>  dateAsc = (ItemDto it1, ItemDto it2) => it1.date!.compareTo(it2.date!);

  static Comparator<ItemDto>  descrDesc = (ItemDto it1, ItemDto it2) => it2.description!.toUpperCase().compareTo(it1.description!.toUpperCase());
  static Comparator<ItemDto>  descrAsc = (ItemDto it1, ItemDto it2) => it1.description!.toUpperCase().compareTo(it2.description!.toUpperCase());

  static Comparator<ItemDto>  valueDesc = (ItemDto it1, ItemDto it2) => it2.value!.compareTo(it1.value!);
  static Comparator<ItemDto>  valueAsc = (ItemDto it1, ItemDto it2) => it1.value!.compareTo(it2.value!);
}