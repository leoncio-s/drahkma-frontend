import 'package:drahkma/features/categories/data/models/categories_dto.dart';
import 'package:drahkma/features/categories/data/models/categories_model.dart';

abstract interface class CategoriesRemoteDatasource
{
  Future<CategoriesModel?> save(CategoriesDTO data);
  Future<void> update(CategoriesDTO data);
  Future<void> delete(CategoriesModel data);
  Future<CategoriesModel?> getBy({int? id});
  Future<List<CategoriesModel>?> getAll();
}