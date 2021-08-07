import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/network/api_request.dart';
import 'package:shopping_app/state/state_management.dart';
import 'package:shopping_app/widgets/size_widget.dart';

class ProductDetailPage extends ConsumerWidget {
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
        watch(_fetchProductById(context.read(productSelected).state.productId));

    var _productSizeSelected = watch(productSizeSelected).state;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: productsApiResult.when(
              /*Image Scroll*/
              data: (products) => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                            items: products.productImages!
                                .map((e) => Builder(
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
                                height: MediaQuery.of(context).size.height /
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
                        '${products.productName}',
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
                                text: products.productOldPrice == 0
                                    ? ''
                                    : '\$${products.productOldPrice}',
                                style: TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough)),
                            TextSpan(
                                text: '\$${products.productNewPrice}',
                                style: TextStyle(fontSize: 14))
                          ]))
                        ],
                      ),
                    ),
                    /*Details*/
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${products.productShortDescription}',
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
                            fontSize: 14, decoration: TextDecoration.underline),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    products.productSizes != null
                        ? Wrap(
                            children: products.productSizes!
                                .map((size) => GestureDetector(
                                      onTap: size.number! > 0
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
                            _productSizeSelected.number! <= 5
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
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          width: double.infinity,
                          child: RaisedButton(
                            color: Colors.black,
                            onPressed: () => print('Click Add to Bag'),
                            child: Text(
                              'Add To Bag',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        /*Wish list , Notify*/
                        Container(
                          margin: const EdgeInsets.only(left: 8, right: 8),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: RaisedButton(
                                  color: Colors.black,
                                  onPressed: () {  },
                                  child: Text(
                                    'WishList',
                                    style: TextStyle(color: Colors.white),
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
                            fontSize: 14, decoration: TextDecoration.underline),
                        textAlign: TextAlign.justify,
                      ),
                    ),

                    /*Product Description*/
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        '${products.productDescription}',
                        style: TextStyle(
                            fontSize: 14, decoration: TextDecoration.underline),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('$error'),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
