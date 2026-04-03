
class CategoryModel {
  final int? id;
  final String? description;

  CategoryModel({this.id, this.description});

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