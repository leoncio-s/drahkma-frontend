import 'package:drahkma/core/mixins/dto.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';

class CategoryDTO extends Category with DTO
{

  CategoryDTO({super.id, super.description});

  factory CategoryDTO.fromModel(CategoryModel category)
  {
    return CategoryDTO(
      id: category.id,
      description: category.description
    );
  }

  @override
  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {"id": id, "description" : description};
    return data;
  }

}