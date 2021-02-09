class OrderResponse {
  int orderId;
  String message;

  OrderResponse({
    this.orderId,
    this.message,
});


  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      orderId: json['OrderId'],
      message: json['Message'],
    );
  }
}