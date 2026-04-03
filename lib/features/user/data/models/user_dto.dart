import 'package:drahkma/core/mixins/dto_mixin.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';

class UserDTO with DTOMixin {
  final int? id;
  final String? fullname;
  final String? email;
  final String? phoneNumber;
  final bool? actived;
  final DateTime? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? token;
  final String? password;
  final String? confirmNewPassword;

  UserDTO({
    this.actived, 
    this.createdAt, 
    this.email, 
    this.emailVerifiedAt, 
    this.fullname, 
    this.id, 
    this.phoneNumber, 
    this.updatedAt, 
    this.password, 
    this.confirmNewPassword, 
    this.token
  });

  factory UserDTO.fromModel(UserModel user) {
    return UserDTO(
      id: user.id,
      phoneNumber: user.phoneNumber,
      fullname: user.fullname,
      createdAt: user.createdAt,
      token: user.token,
      actived: user.actived,
      updatedAt: user.updatedAt,
      email: user.email,
      emailVerifiedAt: user.emailVerifiedAt
    );
  }

  @override
  Map<String, dynamic> toMap(){
    Map<String, String?> data = {
      'fullname' : fullname,
      'email' : email,
      'phone_number' : phoneNumber,
      'password' : password,
      'conf_password' : confirmNewPassword
    };
    if(token != null)
    { 
      Map<String, String?> entrieToken = {"token": token!};
      data.addEntries(entrieToken.entries);
    }
    return data;
  }
}