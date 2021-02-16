import 'package:coffee_app/model/order_detail.dart';

class OrderDetailResponse {
  List<OrderDetail> orderDetails;
  int status;

  OrderDetailResponse({
    this.orderDetails,
    this.status,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    List<OrderDetail> detailsJson = [];

    for (var value in json['orderdetails']) {
      detailsJson.add(OrderDetail.fromJson(value));
    }
    
    return OrderDetailResponse(
      orderDetails: detailsJson,
      status: json['status'],
    );
  }
}
