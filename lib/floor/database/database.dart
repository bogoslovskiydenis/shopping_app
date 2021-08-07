// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:shopping_app/floor/dao/cart_dao.dart';
import 'package:shopping_app/floor/entity/cart_product.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart'; //generate code

@Database(version : 1, entities: [Cart])
abstract class AppDatabase extends FloorDatabase{
  CartDAO get cartDao;
}