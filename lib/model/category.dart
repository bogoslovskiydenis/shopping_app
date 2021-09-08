// To parse this JSON data, do
//
//     final myCategory = myCategoryFromJson(jsonString);

import 'dart:convert';

List<MyCategory> myCategoryFromJson(String str) => List<MyCategory>.from(json.decode(str).map((x) => MyCategory.fromJson(x)));

String myCategoryToJson(List<MyCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyCategory {
  MyCategory({
     this.categoryId,
      this.categoryName,
       this.categoryImg,
     this.subCategories,
  });

  int categoryId;
  String/*!*/ categoryName;
  String/*!*/ categoryImg;
  List<SubCategory> subCategories;

  factory MyCategory.fromJson(Map<String, dynamic> json) => MyCategory(
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    categoryImg: json["categoryImg"],
    subCategories: List<SubCategory>.from(json["subCategories"].map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categoryId": categoryId,
    "categoryName": categoryName,
    "categoryImg": categoryImg,
    "subCategories": List<dynamic>.from(subCategories.map((x) => x.toJson())),
  };
}

class SubCategory {
  SubCategory({
      this.subCategoryId,
      this.subCategoryName,
     this.categoryId,
     this.products,
  });

  int/*!*/ subCategoryId;
  String subCategoryName;
  int categoryId;
  List<dynamic> products;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
    subCategoryId: json["subCategoryId"],
    subCategoryName: json["subCategoryName"],
    categoryId: json["categoryId"],
    products: List<dynamic>.from(json["products"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "subCategoryId": subCategoryId,
    "subCategoryName": subCategoryName,
    "categoryId": categoryId,
    "products": List<dynamic>.from(products.map((x) => x)),
  };
}
