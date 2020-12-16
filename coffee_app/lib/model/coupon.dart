class Coupon{
  String couponId;
  String title;
  String description;
  String image;
  String sale;
  String startDate;
  String expiryDate;

  Coupon({
    this.couponId,
    this.title,
    this.description,
    this.image,
    this.sale,
    this.startDate,
    this.expiryDate,
  });

  factory Coupon.fromJson(Map<dynamic, dynamic> json) {
    return Coupon(
      couponId: json['CouponId'],
      title: json['Title'],
      description: json['Description'],
      image: json['Image'],
      sale: json['Sale'],
      startDate: json['StartDate'],
      expiryDate: json['ExpiryDate'],
    );
  }

}