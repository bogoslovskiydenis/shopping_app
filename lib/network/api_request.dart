import 'dart:convert';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/feature_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shopping_app/model/banner.dart';
import 'package:shopping_app/const/api_cons.dart';
import 'package:shopping_app/model/product.dart';

//region: MyBanner Api request
List <MyBanner> parseBanner(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var banners = l.map((model)=> MyBanner.fromJson(model)).toList();
  return banners;
}
//check code status Banner
Future<List<MyBanner>> fetchBanner ()async
{
  final response = await http.get(Uri.parse('$mainUrl$bannerUrl'));
  if(response.statusCode==200)
    return compute (parseBanner,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Banner');
}
//endregion:

//region: Future Api request
List <FeatureImg> parseFeatureImage (String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var featureImages = l.map((model)=> FeatureImg.fromJson(model)).toList();
  return featureImages;
}

//check code status FeatureImg
Future<List<FeatureImg>> fetchFeatureImages ()async
{
  final response = await http.get(Uri.parse('$mainUrl$featureUrl'));
  if(response.statusCode==200)
    return compute (parseFeatureImage,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Banner');
}
//endregion:

//region : Categories Api request
List <MyCategory> parseCategory(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var categories = l.map((model)=> MyCategory.fromJson(model)).toList();
  return categories;
}
//check code status Categories
Future<List<MyCategory>> fetchCategories ()async
{
  final response = await http.get(Uri.parse('$mainUrl$categoriesUrl'));
  if(response.statusCode==200)
    return compute (parseCategory,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Categories');
}
//endregion:

//region : Products Api request
List <Product> parseProduct(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var products = l.map((model)=> Product.fromJson(model)).toList();
  return products;
}
//check code status Categories
Future<List<Product>> fetchProducts (id)async
{
  final response = await http.get(Uri.parse('$mainUrl$productUrl/$id'));
  if(response.statusCode==200)
    return compute (parseProduct,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Product');
}
Future<List<Product>> fetchProductsBySubCategory (id)async
{
  final response = await http.get(Uri.parse('$mainUrl$productUrl/$id'));
  if(response.statusCode==200)
    return compute (parseProduct,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Product');
}
//endregion:

//region : ProductsDetail Api request
Product parseProductDetail(String responseBody){
  var l = json.decode(responseBody) as dynamic;
  var products =  Product.fromJson(l);
  return products;
}
//check code status Categories
Future<Product> fetchProductsDetail (id)async
{
  final response = await http.get(Uri.parse('$mainUrl$productDetail/$id'));
  if(response.statusCode==200)
    return compute (parseProductDetail,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Product Detail');
}

//endregion:

//region : User Api

Future<String> findUser (id)async
{
  final response = await http.get(Uri.parse('$mainUrl$userPath/$id'));
  if(response.statusCode==200)
    return 'User found';
  else if (response.statusCode == 404)
    return 'Not found';
  else
    throw Exception ('Cannot get User by id');
}

//endregion: