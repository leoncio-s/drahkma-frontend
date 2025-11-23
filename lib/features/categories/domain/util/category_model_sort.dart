import 'package:drahkma/features/categories/data/models/category_model.dart';

class CategoryModelSort{
  static Comparator<CategoryModel> asc = (CategoryModel it1, CategoryModel it2) =>  it1.description!.compareTo(it2.description.toString());

  static Comparator<CategoryModel> desc = (CategoryModel it1, CategoryModel it2) => it2.description!.compareTo(it1.description.toString());
}