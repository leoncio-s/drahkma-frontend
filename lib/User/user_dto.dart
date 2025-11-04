class UserDto{
    int? id;
    String? fullname;
    String? email;
    String? phoneNumber;
    bool? actived;
    DateTime? emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt ;
    String? token;

    UserDto({this.id, this.fullname, this.email, this.actived, this.phoneNumber, this.emailVerifiedAt, this.createdAt, this.updatedAt});


    toObject(dynamic data){
      if(data['user'] != null){
        actived = data['user']['actived'];
        id= data['user']['id'];
        createdAt = data['user']['created_at'] == null ? null : DateTime.tryParse(data['user']['created_at']['date']);
        updatedAt = data['user']['updated_at'] == null?  null : DateTime.tryParse(data['user']['updated_at']['date']);
        emailVerifiedAt = data['user']['email_verified_at'] == null ? null : DateTime.tryParse(data['user']['email_verified_at']['date']);
        fullname = data['user']['fullname'];
        email=data['user']['email'];
        phoneNumber = data['phone_number'];
        token = data['token'];
      }else{
        actived = data['actived'];
        id= data['id'];
        createdAt = data['created_at'] == null ? null : DateTime.tryParse(data['created_at']['date']);
        updatedAt = data['updated_at'] == null?  null : DateTime.tryParse(data['updated_at']['date']);
        emailVerifiedAt = data['email_verified_at'] == null ? null : DateTime.tryParse(data['email_verified_at']['date']);
        fullname = data['fullname'];
        email=data['email'];
        phoneNumber = data['phone_number'];
      }
      return this;
    }

    toMap(dynamic data) => {
      'actived' : actived,
      'id'  : id,
      'created_at' : createdAt,
      'updated_at' : updatedAt,
      'email_verified_at' : emailVerifiedAt,
      'fullname' : fullname,
      'email' : email,
      'phone_number' : phoneNumber,
      'token' : token
    };
}