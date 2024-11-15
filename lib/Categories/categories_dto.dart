import 'package:front_lfinanca/Interfaces/dto_interface.dart';

class CategoriesDto implements DtoInterface{
  int? id;
  String? description;

  CategoriesDto({this.id, this.description});

  
  @override
  factory CategoriesDto.toObject(Map<String, dynamic> data){
    int? _id = data['id'] ?? 0;
    String? _description = data['description'] ?? "";

    return CategoriesDto(id: _id, description: _description);
  }

  @override
  String toString() {
    return "description: $description, id: $id";
  }
  
  // @override
  // int compareTo(CategoriesDto other) {
  //   return other.description!.compareTo(description!);
  // }
  // @override
  // int compareTo(CategoriesDto other){
  //   return other.id! - id!;
  // }

  @override
  Map<String, dynamic> toMap(){
    Map<String, dynamic> data = {"id": id, "description" : description};
    return data;
  }
}