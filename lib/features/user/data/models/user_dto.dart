import 'package:drahkma/core/mixins/dto.dart';
import 'package:drahkma/features/user/data/models/user_model.dart';
import 'package:drahkma/features/user/domain/entities/user.dart';

class UserDTO extends User with DTO
{
  String? token;
  final String? password;
  final String? confirmNewPassword;
  UserDTO({super.actived, super.createdAt, super.email, super.emailVerifiedAt, super.fullname, super.id, super.phoneNumber, super.updatedAt, this.password, this.confirmNewPassword, this.token});

  factory UserDTO.fromModel(UserModel user)
  {
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
      'confPassword' : confirmNewPassword
    };
    if(token != null)
    { 
      Map<String, String?> entrieToken = {"token": token!};
      data.addEntries(entrieToken.entries);
    }
    return data;
  }
}