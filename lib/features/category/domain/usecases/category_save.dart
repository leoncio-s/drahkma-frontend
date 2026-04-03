import 'package:drahkma/core/domain/usecases/use_cases.dart';
import 'package:drahkma/features/category/data/models/category_dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/repositories/category_repository.dart';

class CategorySave implements UseCases<CategoryModel>{
  
  final CategoryRepository _repository;
  CategorySave(CategoryRepository repository) : _repository = repository;
  @override
  Future<CategoryModel?> call({CategoryDTO? category}) async {
    var data = await _repository.save(category!);
    return data;
  }

}