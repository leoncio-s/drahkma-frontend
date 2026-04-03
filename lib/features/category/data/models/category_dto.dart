import 'package:drahkma/core/mixins/dto_mixin.dart';
import 'package:drahkma/features/category/data/models/category_model.dart';

class CategoryDTO with DTOMixin
{
  final int? id;
  final String? description;

  CategoryDTO({this.id, this.description});

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