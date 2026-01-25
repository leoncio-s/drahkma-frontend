
import 'package:drahkma/features/categories/domain/entities/categories.dart';

class CategoriesModel extends Categories{

  CategoriesModel({super.id, super.description});

  factory CategoriesModel.fromJson(Map<String, dynamic> data){
    int? id = data['id'] ?? 0;
    String? description = data['description'] ?? "";
    return CategoriesModel(id: id, description: description);
  }

  @override
  String toString() {
    return "description: $description, id: $id";
  }
}