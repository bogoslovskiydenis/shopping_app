import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/floor/dao/cart_dao.dart';
import 'package:shopping_app/floor/dao/const.dart';

class CartDetail extends StatefulWidget {

  final CartDAO? dao;

  CartDetail({Key? key, this.dao}) :super(key: key);

  @override
  State<StatefulWidget> createState() => CartDetailState();


}

class CartDetailState extends State<CartDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Cart Detail',),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back),),),
      body: StreamBuilder(
      stream: widget.dao!.getAllItemInCartByUid(NOT_SIGN_IN),
        builder: (context, snapshot){
        return Column();
        },
      ),
    );

  }
}
