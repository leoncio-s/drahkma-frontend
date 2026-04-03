import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/data/sources/category_remote_datasource.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository
{

  final CategoryRemoteDatasource _datasource;
  CategoryRepositoryImpl(CategoryRemoteDatasource datasource): _datasource=datasource;

  @override
  Future<void> delete(CategoryModel data) async {
    return await _datasource.delete(data);
  }

  @override
  Future<List<CategoryModel>?> getAll() async {
    return await _datasource.getAll();
  }

  Future<List<CategoryModel>?> getAllByUser() async {
    return await _datasource.getAllByUser();
  }

  @override
  Future<CategoryModel?> getBy({int? id}) async {
    return await _datasource.getBy(id: id);
  }

  @override
  Future<CategoryModel?> save(Category data) async {
    return await _datasource.save(data as CategoryDTO);
  }

  @override
  Future<void> update(Category data) async {
    return await _datasource.update(data as CategoryDTO);
  }
  
}