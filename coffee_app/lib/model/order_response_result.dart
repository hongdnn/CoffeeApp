class OrderResponse {
  int orderId;
  int amountDetail;
  String message;

  OrderResponse({
    this.orderId,
    this.amountDetail,
    this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['OrderId'],
      message: json['Message'],
    );
  }

  factory OrderResponse.getAmountfromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['OrderId'],
      amountDetail: json['AmountDetail'],
      message: json['Message'],
    );
  }
}
