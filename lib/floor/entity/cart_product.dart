import 'package:floor/floor.dart';

@entity
class Cart {
  @primaryKey
  final int productId;
  final String uid, name, imageUrl, size, code;

  Cart(
      { required this.productId,
      required this.uid,
        required  this.name,
        required this.imageUrl,
        required this.size,
        required this.code,
      this.price, required this.quantity});

  double? price;
  int? quantity;
}
