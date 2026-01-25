import 'package:drahkma/features/category/domain/entities/category.dart';

abstract interface class CategoryRepository
{
  Future<Category?> save(Category data);
  Future<void> update(Category data);
  Future<void> delete(Category data);
  Future<Category?> getBy({int? id});
  Future<List<Category>?> getAll();
}