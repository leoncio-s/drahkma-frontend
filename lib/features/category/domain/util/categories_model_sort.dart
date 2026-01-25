import 'package:drahkma/features/categories/data/models/categories_model.dart';

class CategoriesModelSort{
  static Comparator<CategoriesModel> asc = (CategoriesModel it1, CategoriesModel it2) =>  it1.description!.compareTo(it2.description.toString());

  static Comparator<CategoriesModel> desc = (CategoriesModel it1, CategoriesModel it2) => it2.description!.compareTo(it1.description.toString());
}