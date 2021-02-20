import 'package:coffee_app/model/order_detail.dart';

class OrderDetailResponse {
  List<OrderDetail> orderDetails;
  int totalPrice;
  int status;

  OrderDetailResponse({
    this.orderDetails,
    this.totalPrice,
    this.status,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    List<OrderDetail> detailsJson = [];

    for (var value in json['orderdetails']) {
      detailsJson.add(OrderDetail.fromJson(value));
    }

    return OrderDetailResponse(
      orderDetails: detailsJson,
      totalPrice: json['totalPrice'],
      status: json['status'],
    );
  }
}
