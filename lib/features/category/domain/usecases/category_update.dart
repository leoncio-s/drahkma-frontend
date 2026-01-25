import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategoryUpdate implements UseCases
{
  final CategoryRepository _repository;
  CategoryUpdate(CategoryRepository repository) : _repository=repository;

  @override
  Future<void> call({CategoryDTO? category}) async{
    await _repository.delete(category!);
    return;
  }
  
}