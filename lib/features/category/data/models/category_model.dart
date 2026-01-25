
import 'package:drahkma/features/category/domain/entities/Category.dart';

class CategoryModel extends Category{

  CategoryModel({super.id, super.description});

  factory CategoryModel.fromJson(Map<String, dynamic> data){
    int? id = data['id'] ?? 0;
    String? description = data['description'] ?? "";
    return CategoryModel(id: id, description: description);
  }

  @override
  String toString() {
    return "description: $description, id: $id";
  }
}