import 'package:shopping_app/model/size.dart';

class ProductSize {
  ProductSize({
     this.sizeId,
     this.productId,
     this.number,
     this.size,
  });

  int sizeId;
  int productId;
  int number;
  MySize size;

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
    sizeId: json["sizeId"],
    productId: json["productId"],
    number: json["number"],
    size: MySize.fromJson(json["size"]),

  );

  Map<String, dynamic> toJson() => {
    "sizeId": sizeId,
    "productId": productId,
    "number": number,
    "size": size.toJson(),
  };
}