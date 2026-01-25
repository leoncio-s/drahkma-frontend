import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategoryGetAll implements UseCases<List<CategoryModel>?>
{
  final CategoryRepository _repository;
  CategoryGetAll(CategoryRepository repository) : _repository = repository;
  
  @override
  Future<List<CategoryModel>?> call() async {
    var data = await _repository.getAll();
    return data;
  }
}