import 'package:drahkma/features/categories/domain/entities/categories.dart';

abstract interface class CategoriesRepository
{
  Future<Categories?> save(Categories data);
  Future<void> update(Categories data);
  Future<void> delete(Categories data);
  Future<Categories?> getBy({int? id});
  Future<List<Categories>?> getAll();
}