import 'package:drahkma/features/user/data/models/user_dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

class UserMapper {
  /// Convert UserModel to User entity
  static User toEntity(UserModel model) {
    return User(
      id: model.id,
      fullname: model.fullname,
      email: model.email,
      phoneNumber: model.phoneNumber,
      actived: model.actived,
      emailVerifiedAt: model.emailVerifiedAt,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert User entity to UserModel
  static UserModel toModel(User entity) {
    return UserModel(
      id: entity.id,
      fullname: entity.fullname,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      actived: entity.actived,
      emailVerifiedAt: entity.emailVerifiedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static UserDTO entytyToDTO(User entity) {
    return UserDTO(
      id: entity.id,
      fullname: entity.fullname,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      actived: entity.actived,
      emailVerifiedAt: entity.emailVerifiedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
