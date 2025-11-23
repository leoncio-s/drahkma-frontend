
import 'package:drahkma/features/categories/domain/entities/category.dart';

class CategoryModel extends Category{

  CategoryModel({super.id, super.description});

  
  @override
  factory CategoryModel.toObject(Map<String, dynamic> data){
    // ignore: no_leading_underscores_for_local_identifiers
    int? _id = data['id'] ?? 0;
    // ignore: no_leading_underscores_for_local_identifiers
    String? _description = data['description'] ?? "";

    return CategoryModel(id: _id, description: _description);
  }

  @override
  String toString() {
    return "description: $description, id: $id";
  }
  
  
  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {"id": id, "description" : description};
    return data;
  }
}