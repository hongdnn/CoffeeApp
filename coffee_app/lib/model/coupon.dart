import 'package:hive/hive.dart';

part 'coupon.g.dart';

@HiveType(typeId: 0)
class Coupon extends HiveObject{
  @HiveField(0)
  String couponId;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String image;
  @HiveField(4)
  String sale;
  @HiveField(5)
  int condition;
  @HiveField(6)
  int status;
  @HiveField(7)
  String createDate;
  @HiveField(8)
  String startDate;
  @HiveField(9)
  String expiryDate;

  Coupon({
    this.couponId,
    this.title,
    this.description,
    this.image,
    this.sale,
    this.condition,
    this.status,
    this.startDate,
    this.createDate,
    this.expiryDate,
  });

  factory Coupon.fromJson(Map<dynamic, dynamic> json) {
    return Coupon(
      couponId: json['CouponId'],
      title: json['Title'],
      description: json['Description'],
      image: json['Image'],
      sale: json['Sale'],
      condition: json['Condition'],
      status: json['Status'],
      createDate: json['CreateDate'],
      startDate: json['StartDate'],
      expiryDate: json['ExpiryDate'],
    );
  }
}
