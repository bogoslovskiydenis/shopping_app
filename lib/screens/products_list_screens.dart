import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/network/api_request.dart';
import 'package:shopping_app/state/state_management.dart';
import 'package:shopping_app/widgets/product_card.dart';

class ProductListPage extends ConsumerWidget {
  //ignore: top_level_function_literal_block
  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  //ignore: top_level_function_literal_block
  final _fetchProductBySubCategory =
      FutureProvider.family<List<Product>, int>((ref, subCategoryId) async {
    var result = await fetchProductsBySubCategory(subCategoryId);
    return result;
  });

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var categoriesApiResult = watch(_fetchCategories);

    var productsApiResult = watch(_fetchProductBySubCategory(
        context.read(subCategorySelected).state.subCategoryId));

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: categoriesApiResult.when(
          data: (categories) => ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(categories[index].categoryImg),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        categories[index].categoryName.length <= 10
                            ? Text(categories[index].categoryName)
                            : Text(
                                categories[index].categoryName,
                                style: TextStyle(fontSize: 12),
                              )
                      ],
                    ),
                    children: _buildList(categories[index]),
                  ),
                ),
              );
            },
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('$error'),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.menu,
                          size: 35,
                          color: Colors.black,
                        ),
                        onPressed: () =>
                            _scaffoldKey.currentState.openDrawer()),
                    Text(
                      "Shopping App",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.account_circle_rounded,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amberAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                              child: Text(
                                  '${context.read(subCategorySelected).state.subCategoryName}'),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            Expanded(
                child: productsApiResult.when(
              data: (products) => GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                childAspectRatio: 0.46,
                children: products.map((e) => ProductCard(product: e)).toList(),
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
