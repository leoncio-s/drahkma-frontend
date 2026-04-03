import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategoryGetAllByUser implements UseCases<List<CategoryModel>?>
{
  final CategoryRepository _repository;
  CategoryGetAllByUser(CategoryRepository repository) : _repository = repository;
  
  @override
  Future<List<CategoryModel>?> call() async {
    var data = await _repository.getAllByUser();
    return data;
  }
}