import 'package:drahkma/features/users/domain/entities/user.dart';

class UserModel extends User {
    String? token;

    UserModel({super.id, super.fullname, super.email, super.actived, super.phoneNumber, super.emailVerifiedAt, super.createdAt, super.updatedAt, this.token});


    @override
    factory UserModel.toObject(Map data){
      final int? id;
      final String? fullname;
      final String? email;
      final String? phoneNumber;
      final bool? actived;
      final DateTime? emailVerifiedAt;
      final DateTime? createdAt;
      final DateTime? updatedAt;
      String? token = '';
      
      if(data['user'] != null){
        actived = data['user']['actived'];
        id= data['user']['id'];
        createdAt = data['user']['created_at'] == null ? null : DateTime.tryParse(data['user']['created_at']);
        updatedAt = data['user']['updated_at'] == null?  null : DateTime.tryParse(data['user']['updated_at']);
        emailVerifiedAt = data['user']['email_verified_at'] == null ? null : DateTime.tryParse(data['user']['email_verified_at']);
        fullname = data['user']['fullname'];
        email=data['user']['email'];
        phoneNumber = data['user']['phone_number'];
        token = data['token'];
      }else{
        actived = data['actived'];
        id= data['id'];
        createdAt = DateTime.tryParse(data['created_at'].toString());
        updatedAt = DateTime.tryParse(data['updated_at'].toString());
        emailVerifiedAt = DateTime.tryParse(data['email_verified_at'].toString());
        fullname = data['fullname'];
        email=data['email'];
        phoneNumber = data['phone_number'];
        token = data['token'] ?? "";
      }
      return UserModel(
        id: id,
        fullname: fullname,
        email: email,
        actived: actived,
        phoneNumber: phoneNumber,
        emailVerifiedAt: emailVerifiedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        token: token
      );
    }

    Map toMap() => {
      'actived' : actived,
      'id'  : id,
      'created_at' : createdAt?.toIso8601String(),
      'updated_at' : updatedAt?.toIso8601String(),
      'email_verified_at' : emailVerifiedAt?.toIso8601String(),
      'fullname' : fullname,
      'email' : email,
      'phone_number' : phoneNumber,
      'token' : token
    };
}