import 'package:drahkma/features/users/data/models/user_model.dart';

class UserDto extends UserModel
{
  final String? password;
  final String? confirmNewPassword;
  UserDto({super.actived, super.createdAt, super.email, super.emailVerifiedAt, super.fullname, super.id, super.phoneNumber, super.updatedAt, this.password, this.confirmNewPassword});


  @override
  Map<String, dynamic> toJson()=>
  {
      'fullname' : fullname,
      'email' : email,
      'phone_number' : phoneNumber,
      'password' : password,
      'confPassword' : confirmNewPassword
  };
}