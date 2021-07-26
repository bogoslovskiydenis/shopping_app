
import 'package:flutter_riverpod/all.dart';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/product.dart';

final subCategorySelected = StateProvider((ref)=> SubCategories());
final productSelected = StateProvider((ref)=> Product());