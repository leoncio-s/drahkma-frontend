import 'package:drahkma/features/category/data/models/category_model.dart';
import 'package:drahkma/features/category/domain/entities/category.dart';

class CategoryMapper {
  /// Convert CategoryModel to Category entity
  static Category toEntity(CategoryModel model) {
    return Category(
      id: model.id,
      description: model.description,
    );
  }

  /// Convert Category entity to CategoryModel
  static CategoryModel toModel(Category entity) {
    return CategoryModel(
      id: entity.id,
      description: entity.description,
    );
  }
}
