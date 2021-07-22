import 'dart:convert';
import 'package:shopping_app/model/category.dart';
import 'package:shopping_app/model/feature_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shopping_app/model/banner.dart';
import 'package:shopping_app/const/api_cons.dart';

//region: MyBanner Api request
List <MyBanner> parseBanner(String responseBody){
  var l = json.decode(responseBody) as List<dynamic>;
  var banners = l.map((model)=> MyBanner.fromJson(model)).toList();
  return banners;
}
//check code status Banner
Future<List<MyBanner>> fetchBanner ()async
{
  final response = await http.get('$mainUrl$bannerUrl');
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
  final response = await http.get('$mainUrl$featureUrl');
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
Future<List<FeatureImg>> fetchCategories ()async
{
  final response = await http.get('$mainUrl$categoriesUrl');
  if(response.statusCode==200)
    return compute (parseFeatureImage,response.body);
  else if (response.statusCode == 404)
    throw Exception('Not found');
  else
    throw Exception ('Cannot get Categories');
}
//endregion: req re