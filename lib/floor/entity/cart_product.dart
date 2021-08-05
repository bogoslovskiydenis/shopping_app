import 'package:floor/floor.dart';

@entity
class Cart {
  @primaryKey
  final int productId;
  final String uid, name, imageUrl, size, code;

  Cart(
      {this.productId,
      this.uid,
      this.name,
      this.imageUrl,
      this.size,
      this.code,
      this.price,
      this.quantity});

  double price;
  int quantity;
}
