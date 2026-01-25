import 'package:drahkma/core/mixins/dto.dart';
import 'package:drahkma/features/categories/domain/entities/categories.dart';

class CategoriesDTO extends Categories with DTO
{

  CategoriesDTO({super.id, super.description});

  @override
  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {"id": id, "description" : description};
    return data;
  }

}