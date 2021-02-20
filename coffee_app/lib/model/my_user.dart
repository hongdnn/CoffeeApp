
import 'package:hive/hive.dart';

part 'my_user.g.dart';

@HiveType(typeId: 1)
class MyUser{
  @HiveField(0)
  String userId;
  @HiveField(1)
  String fullname;
  @HiveField(2)
  String email;
  @HiveField(3)
  String phone;
  @HiveField(4)
  String address;
  @HiveField(5)
  String providerId;
  @HiveField(6)
  String image;
  @HiveField(7)
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