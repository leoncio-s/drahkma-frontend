import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategoryDelete implements UseCases
{
  final CategoryRepository _repository;
  CategoryDelete(CategoryRepository repository): _repository=repository;

  @override
  Future<void> call({CategoryModel? category}) async
  {
    await _repository.delete(category!);
  }
}