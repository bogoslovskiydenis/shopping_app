import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/const/utils.dart';
import 'package:shopping_app/floor/dao/cart_dao.dart';
import 'package:shopping_app/floor/dao/const.dart';
import 'package:shopping_app/floor/entity/cart_product.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/network/api_request.dart';
import 'package:shopping_app/state/state_management.dart';
import 'package:shopping_app/widgets/size_widget.dart';

class ProductDetailPage extends ConsumerWidget {
  final CartDAO dao;

  ProductDetailPage({ this.dao});

  //ignore: top_level_function_literal_block
  final _fetchProductById =
  FutureProvider.family<Product, int>((ref, id) async {
    var result = await fetchProductsDetail(id);
    return result;
  });

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var productsApiResult =
    watch(_fetchProductById(context
        .read(productSelected)
        .state
        .productId));

    var _productSizeSelected = watch(productSizeSelected).state;

    return Scaffold(
      body: Builder(builder: (context) {
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: productsApiResult.when(
                    /*Image Scroll*/
                    data: (product) =>
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CarouselSlider(
                                      items: product.productImages
                                          .map((e) =>
                                          Builder(
                                            builder: (context) {
                                              return Container(
                                                child: Image(
                                                  image: NetworkImage(e.imgUrl),
                                                  fit: BoxFit.fill,
                                                ),
                                              );
                                            },
                                          ))
                                          .toList(),
                                      options: CarouselOptions(
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height /
                                              3 *
                                              2.5,
                                          autoPlay: true,
                                          viewportFraction: 1,
                                          initialPage: 0))
                                ],
                              ),
                              /*Name of Product*/
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${product.productName}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              /* Price of Product */
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text.rich(TextSpan(children: [
                                      TextSpan(
                                          text: product.productOldPrice == 0
                                              ? ''
                                              : '\$${product.productOldPrice}',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              decoration: TextDecoration
                                                  .lineThrough)),
                                      TextSpan(
                                          text: '\$${product.productNewPrice}',
                                          style: TextStyle(fontSize: 14))
                                    ]))
                                  ],
                                ),
                              ),
                              /*Details*/
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${product.productShortDescription}',
                                  style: TextStyle(fontSize: 14),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              /*Size*/
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Size',
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                              product.productSizes != null
                                  ? Wrap(
                                children: product.productSizes
                                    .map((size) =>
                                    GestureDetector(
                                      onTap: size.number > 0
                                          ? () {
                                        context
                                            .read(productSizeSelected)
                                            .state = size;
                                      }
                                          : null,
                                      child: SizeWidget(
                                          SizeModel(
                                              _productSizeSelected.size ==
                                                  size.size,
                                              size),
                                          size),
                                    ))
                                    .toList(),
                              )
                                  : Container(),
                              /*warning*/
                              _productSizeSelected.number != null &&
                                  _productSizeSelected.number <= 5
                                  ? Center(
                                child: Text(
                                  'Only ${_productSizeSelected.number} left',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.redAccent),
                                ),
                              )
                                  : Container(),

                              /*button*/
                              Column(
                                children: [
                                  /*ADD To bag*/
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    width: double.infinity,
                                    child: RaisedButton(
                                      color: Colors.black,
                                      //if we have choose Size , we will cant click button
                                      onPressed: _productSizeSelected.size == null? null:() async {
                                        try {
                                          //get product
                                          //not implement sign in , UID null
                                          var cartProduct = await dao
                                              .getItemInCartByUid(NOT_SIGN_IN, product.productId);
                                          if (cartProduct != null ) {
                                            //if alryeady avaible item in cart
                                            cartProduct.quantity = 1;
                                            showSnackBarWithViewBag(
                                                context, 'Update item in bag');
                                          } else {
                                            Cart cart = Cart(
                                                productId: product.productId
                                        ,
                                        price: product.productNewPrice,
                                        quantity: 1,
                                        size: _productSizeSelected.size.sizeName,
                                        imageUrl : product.productImages[0].imgUrl,
                                        name: product.productName,
                                        uid: NOT_SIGN_IN, code: ''
                                            );
                                            await dao.insertCart(cart);
                                            showSnackBarWithViewBag(
                                                context, 'Add item to bag');
                                          }
                                        } catch (e) {
                                          showOnlySnackBar(
                                              context, '$e');
                                        }
                                      },
                                      child: Text(
                                        'Add To Bag',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  /*Wish list , Notify*/
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: RaisedButton(
                                            color: Colors.black,
                                            onPressed: () {},
                                            child: Text(
                                              'WishList',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        /*Notify*/
                                        SizedBox(
                                          width: 20,
                                        ),
                                        // Expanded(
                                        //   child:const RaisedButton(
                                        //     color: Colors.black,
                                        //     child: Text(
                                        //       'Notify',
                                        //       style: TextStyle(color: Colors.white),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  )
                                ],
                              ),

                              /*Detail*/
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Finner Details',
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.justify,
                                ),
                              ),

                              /*Product Description*/
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  '${product.productDescription}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.underline),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                        ),
                    loading: () =>
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, stack) =>
                        Center(
                          child: Text('$error'),
                        ),
                  ))
            ],
          ),
        );
      }),
    );
  }

}
