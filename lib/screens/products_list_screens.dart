import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_auth_ui/firebase_auth_ui.dart';
import 'package:firebase_auth_ui/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/const/utils.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/network/api_request.dart';
import 'package:shopping_app/state/state_management.dart';
import 'package:shopping_app/widgets/product_card.dart';

import 'auth.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var categoriesApiResult = watch(_fetchCategories);

    var productsApiResult = watch(_fetchProductBySubCategory(
        context.read(subCategorySelected).state.subCategoryId));

    var userWatch =watch(userLogged);

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
                        FutureBuilder(
                            future: _checkLoginState(),
                            builder: (context, snapshot) {
                          var user = snapshot.data as FirebaseAuth.User;
                          return IconButton(
                            icon: Icon(
                                user == null ? Icons.account_circle  : Icons.exit_to_app,
                                size: 35,
                                color: Colors.black),
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> AuthorizationPage())),
                          );
                        }),
                        IconButton(
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            size: 35,
                            color: Colors.black,
                          ),
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/cartDetail'),
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
    var list = <Widget>[];
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

Future<FirebaseAuth.User>  _checkLoginState() async {
    if(FirebaseAuth.FirebaseAuth.instance.currentUser !=null){
      FirebaseAuth.FirebaseAuth.instance.currentUser.getIdToken().then((token) {
        print('Token $token');
      });
    }
return FirebaseAuth.FirebaseAuth.instance.currentUser;
}

  processLogin(BuildContext context) async {

    var user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    if(user == null){
      FirebaseAuthUi.instance().launchAuth([AuthProvider.phone()])
          .then((firebaseUser) => context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser).catchError((e){
            if(e is PlatformException){
              if(e.code == FirebaseAuthUi.kUserCancelledError)
                showOnlySnackBar(context, 'User canceled login');
              else
                showOnlySnackBar(context, '${e.message ?? 'Unknown error'}' );
            }
      });
    }
    else{
      var result = await FirebaseAuthUi.instance().logout();
      if(result){
        showOnlySnackBar(context, 'Logout success fully');
        //Refresh
        context.read(userLogged).state = FirebaseAuth.FirebaseAuth.instance.currentUser;
        }
          else
          showOnlySnackBar(context , 'Logout error');
    }
  }
}
