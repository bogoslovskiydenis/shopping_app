import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/network/api_request.dart';
import 'package:shopping_app/state/state_management.dart';
import 'package:shopping_app/widgets/product_card.dart';

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


    var productsApiResult = watch(_fetchProductById(
        context.read(productSelected).state.productId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: productsApiResult.when(
                  data: (products) => Center(child: Text('Product : ${products.productName}'),),
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

  _buildList(MyCategory category) {
    var list = new List<Widget>();
    category.subCategories.forEach((element) {
      list.add(Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          element.subCategoryName,
          style: TextStyle(fontSize: 12),
        ),
      ));
    });
    return list;
  }
}
