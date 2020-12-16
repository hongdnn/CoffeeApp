class Size{
  String sizeId;
  int priceOfSizeS;
  int priceOfSizeM;
  int priceOfSizeL;

  Size({
    this.sizeId,
    this.priceOfSizeS,
    this.priceOfSizeM,
    this.priceOfSizeL,
  });

  factory Size.fromJson(Map<dynamic, dynamic> json) {
    return Size(
      sizeId: json['SizeId'],
      priceOfSizeS: json['PriceOfSizeS'],
      priceOfSizeM: json['PriceOfSizeM'],
      priceOfSizeL: json['PriceOfSizeL'],
    );
  }
}