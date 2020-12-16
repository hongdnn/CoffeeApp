class Product{
  String productId;
  String productName;
  int typeId;
  String sizeId;
  String description;
  String image;

  Product({
    this.productId,
    this.productName,
    this.typeId,
    this.sizeId,
    this.description,
    this.image,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      productId: json['ProductId'],
      productName: json['ProductName'],
      typeId: json['TypeId'],
      sizeId: json['SizeId'],
      description: json['Description'],
      image: json['Image'],
    );
  }
}