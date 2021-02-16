class OrderDetail {
  int detailId;
  int orderId;
  String productId;
  String productName;
  String size;
  int quantity;
  int unitPrice;
  String order;
  String product;

  OrderDetail(
      {this.detailId,
      this.orderId,
      this.productId,
      this.productName,
      this.size,
      this.quantity,
      this.unitPrice,
      this.order,
      this.product});

  factory OrderDetail.fromJson(Map<dynamic, dynamic> json) {
    return OrderDetail(
      detailId: json['DetailId'],
      orderId: json['OrderId'],
      productId: json['ProductId'],
      productName: json['ProductName'],
      size: json['Size'],
      quantity: json['Quantity'],
      unitPrice: json['UnitPrice'],
      order: json['Order'],
      product: json['Product'],
    );
  }
}
