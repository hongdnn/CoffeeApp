import 'package:coffee_app/model/product.dart';
import 'size.dart';

class ListData{
  List<Product> listProduct;
  List<Size> listSize;

  ListData({
    this.listProduct,
    this.listSize,
  });

  factory ListData.fromJson(Map<String, dynamic> json) {
    List<Product> productsJson=[];
    List<Size> sizesJson=[];
    
    for(var value in json['Products']){
      productsJson.add(Product.fromJson(value));
    }
    
    for(var value in json['Sizes']){
      sizesJson.add(Size. fromJson(value));
    }

    return ListData(
      listProduct: productsJson,
      listSize: sizesJson,
      
    );
  }
}