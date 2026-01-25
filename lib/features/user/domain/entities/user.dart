class User{
    final int? id;
    final String? fullname;
    final String? email;
    final String? phoneNumber;
    final bool? actived;
    final DateTime? emailVerifiedAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;

    User({this.id, this.fullname, this.email, this.actived, this.phoneNumber, this.emailVerifiedAt, this.createdAt, this.updatedAt});
}