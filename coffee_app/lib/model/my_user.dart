class MyUser{
  String userId;
  String fullname;
  String email;
  String phone;
  String address;
  String providerId;
  String image;
  String createDate;

  MyUser({
    this.userId,
    this.fullname,
    this.email,
    this.phone,
    this.address,
    this.providerId,
    this.image,
    this.createDate,
  });

  Map phoneToJson() => {
        'UserId': userId,
        'Fullname': fullname,
        'Identifier': phone,
        'ProviderId': providerId,
        'Image': image,
      };

  Map emailToJson() => {
        'UserId': userId,
        'Fullname': fullname,
        'Identifier': email,
        'ProviderId': providerId,
        'Image': image,
      };

  factory MyUser.fromJson(Map<dynamic, dynamic> json) {
    return MyUser(
      userId: json['UserId'],
      fullname: json['Fullname'],
      email: json['Email'],
      phone: json['Phone'],
      address: json['Address'],
      providerId: json['ProviderId'],
      image: json['Image'],
    );
  }
}