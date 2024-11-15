class UserDto{
    int? id;
    String? fullname;
    String? email;
    String? phone_number;
    bool? actived;
    DateTime? email_verified_at;
    DateTime? created_at;
    DateTime? updated_at ;
    String? token;

    UserDto({this.id, this.fullname, this.email, this.actived, this.phone_number, this.email_verified_at, this.created_at, this.updated_at});


    toObject(dynamic data){
      if(data['user'] != null){
        actived = data['user']['actived'];
        id= data['user']['id'];
        created_at = data['user']['created_at'] == null ? null : DateTime.tryParse(data['user']['created_at']['date']);
        updated_at = data['user']['updated_at'] == null?  null : DateTime.tryParse(data['user']['updated_at']['date']);
        email_verified_at = data['user']['email_verified_at'] == null ? null : DateTime.tryParse(data['user']['email_verified_at']['date']);
        fullname = data['user']['fullname'];
        email=data['user']['email'];
        phone_number = data['phone_number'];
        token = data['token'];
      }else{
        actived = data['actived'];
        id= data['id'];
        created_at = data['created_at'] == null ? null : DateTime.tryParse(data['created_at']['date']);
        updated_at = data['updated_at'] == null?  null : DateTime.tryParse(data['updated_at']['date']);
        email_verified_at = data['email_verified_at'] == null ? null : DateTime.tryParse(data['email_verified_at']['date']);
        fullname = data['fullname'];
        email=data['email'];
        phone_number = data['phone_number'];
      }
      

      return this;
    }
}