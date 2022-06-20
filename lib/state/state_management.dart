import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/models.dart';

final subCategorySelected = StateProvider((ref)=> SubCategory(subCategoryName: '', subCategoryId: 0));
final productSelected = StateProvider((ref)=> Product(productName: '', productShortDescription: '',
    productDescription: '', productSubText: '', productCode: '', productId: 0));
final productSizeSelected = StateProvider ((ref)=> ProductSize());