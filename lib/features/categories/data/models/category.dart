
class Category{
  int? id;
  String? description;

  Category({this.id, this.description});

  
  @override
  factory Category.toObject(Map<String, dynamic> data){
    // ignore: no_leading_underscores_for_local_identifiers
    int? _id = data['id'] ?? 0;
    // ignore: no_leading_underscores_for_local_identifiers
    String? _description = data['description'] ?? "";

    return Category(id: _id, description: _description);
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