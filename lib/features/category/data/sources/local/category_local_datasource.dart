import 'package:drahkma/features/category/domain/entities/category.dart';

abstract interface class CategoryLocalDatasource {
  Future<void> saveCategories(List<Category> categories);
  Future<List<Category>?> getCategories();
  Future<void> clearCategories();
}
