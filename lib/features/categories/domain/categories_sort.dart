import 'package:drahkma/features/categories/data/models/category.dart';

class CategoriesSort{
  static Comparator<Category> asc = (Category it1, Category it2) =>  it1.description!.compareTo(it2.description.toString());

  static Comparator<Category> desc = (Category it1, Category it2) => it2.description!.compareTo(it1.description.toString());
}