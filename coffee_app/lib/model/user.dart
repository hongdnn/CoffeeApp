class User{
  String userId;
  String fullname;
  String email;
  String phone;
  String address;
  String providerId;
  String image;
  String createDate;

  User({
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
}