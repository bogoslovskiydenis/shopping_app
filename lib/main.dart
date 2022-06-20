import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shopping_app/floor/database/database.dart';
import 'package:shopping_app/screens/cart_detail.dart';
import 'package:shopping_app/screens/product_detail_page.dart';
import 'package:shopping_app/screens/products_list_screens.dart';
import 'floor/dao/cart_dao.dart';
import 'widgets/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('shopping_app.db').build();
  final dao = database.cartDao;

  runApp(ProviderScope(
      child: MyApp(
    dao: dao,
  )));
}

class MyApp extends StatelessWidget {
  final CartDAO dao;

  MyApp({required this.dao});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/productList':
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductListPage(),
                settings: settings);

          case '/productDetail':
            return PageTransition(
                type: PageTransitionType.fade,
                child: ProductDetailPage(dao: dao),
                settings: settings);

          case '/cartDetail':
            return PageTransition(
                type: PageTransitionType.fade,
                child: CartDetail(dao: dao),
                settings: settings);
          default:
            return null;
        }
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}