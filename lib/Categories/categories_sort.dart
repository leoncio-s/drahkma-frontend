import 'package:front_lfinanca/Categories/categories_dto.dart';

class CategoriesSort{
  static Comparator<CategoriesDto> asc = (CategoriesDto it1, CategoriesDto it2) =>  it1.description!.compareTo(it2.description.toString());

  static Comparator<CategoriesDto> desc = (CategoriesDto it1, CategoriesDto it2) => it2.description!.compareTo(it1.description.toString());
}