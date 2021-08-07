import 'package:floor/floor.dart';
import 'package:shopping_app/floor/entity/cart_product.dart';

@dao
abstract class CartDAO {
  //select uid
  @Query('SELECT * FROM Cart WHERE uid=:uid')
  Stream<List<Cart?>> getAllItemInCartByUid(String uid);

  //select uid / productId
  @Query('SELECT * FROM Cart WHERE uid=:uid and productId=:id ')
  Future<Cart?> getItemInCartByUid(String uid, int id);

  //delete uid
  @Query('DELETE FROM Cart WHERE uid=:uid')
  Stream<List<Cart?>> clearCartByUid(String uid);

  //update uid
  @Query('UPDATE Cart SET uid=:uid')
  Future<void> updateUidCart(String uid);

  @insert
  Future<void> insertCart(Cart product);

  @update
  Future<int> updateCart(Cart product);

  @delete
  Future<int> deleteCart(Cart product);
}
