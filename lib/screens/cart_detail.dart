import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopping_app/floor/dao/cart_dao.dart';
import 'package:shopping_app/floor/dao/const.dart';
import 'package:shopping_app/floor/entity/cart_product.dart';

class CartDetail extends StatefulWidget {
  final CartDAO? dao;

  CartDetail({Key? key, this.dao}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CartDetailState();
}

class CartDetailState extends State<CartDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart Detail',
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: StreamBuilder(
        stream: widget.dao!.getAllItemInCartByUid(NOT_SIGN_IN),
        builder: (context, snapshot) {
          var items = snapshot.data as List<Cart>;
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: items == null ? 0 : items.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Delete',
                              icon: Icons.delete,
                              foregroundColor: Colors.red,
                              color: Colors.white,
                              onTap: () async {
                                await widget.dao!.deleteCart(items[index]);
                              },
                            )
                          ],
                          child: Card(
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      child: Image(
                                          image: NetworkImage(
                                              items[index].imageUrl),
                                          fit: BoxFit.fill),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4)),
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          /*Product Name*/
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Text(
                                              items[index].name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              maxLines: 2,
                                            ),
                                          ),
                                          /*Product Price*/
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .monetization_on_rounded,
                                                    color: Colors.grey,
                                                    size: 16),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 8),
                                                  child: Text(
                                                      '${items[index].price}',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              ],
                                            ),
                                          ),
                                          /*Product Size*/
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Size ${items[index].size}',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Center(
                                      child: ElegantNumberButton(
                                    initialValue: items[index].quantity!,
                                    minValue: 1,
                                    maxValue: 100,
                                    buttonSizeHeight: 20,
                                    buttonSizeWidth: 25,
                                    decimalPlaces: 0,
                                    color: Colors.white,
                                    onChanged: (value) async {
                                      items[index].quantity = value as int?;
                                      await widget.dao!
                                          .updateCart(items[index]);
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '\$${items.length > 0 ? items.map<double>((m) => m.price! * m.quantity!).reduce((value, element) => value + element).toStringAsFixed(2) : 0}')
                        ],
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Delivery charge',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '\$${items.length > 0 ? (items.map<double>((m) => m.price! * m.quantity!).reduce((value, element) => value + element)*0.1).toStringAsFixed(2) : 0}')
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sub Total',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              '\$${items.length > 0 ? ((items.map<double>((m) => m.price! * m.quantity!).reduce((value, element) => value + element))
                                  + items.map<double>((m) => m.price! * m.quantity!).reduce((value, element) => value + element)*0.1).toStringAsFixed(2) : 0}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
