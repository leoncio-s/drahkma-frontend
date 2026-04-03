import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';

abstract interface class CategoryRemoteDatasource
{
  Future<CategoryModel?> save(CategoryDTO data);
  Future<void> update(CategoryDTO data);
  Future<void> delete(CategoryModel data);
  Future<CategoryModel?> getBy({int? id});
  Future<List<CategoryModel>?> getAll();
  Future<List<CategoryModel>?> getAllByUser();
}