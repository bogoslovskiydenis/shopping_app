
import 'package:flutter_riverpod/all.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/product.dart';
import 'package:shopping_app/model/product_size.dart';

final subCategorySelected = StateProvider((ref)=> SubCategory(subCategoryName: '', subCategoryId: 0));
final productSelected = StateProvider((ref)=> Product(productId: 0));
final productSizeSelected = StateProvider ((ref)=> ProductSize());