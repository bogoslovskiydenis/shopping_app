import 'dart:convert';

List<MyBanner> myBannerFromJson(String str) => List<MyBanner>.from(json.decode(str).map((x) => MyBanner.fromJson(x)));

String myBannerToJson(List<MyBanner> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyBanner {
  MyBanner({
    required this.bannerImgId,
    required this.bannerImgUrl,
    this.categoryId,
    required this.bannerText,
  });

  int bannerImgId;
  String bannerImgUrl;
  dynamic categoryId;
  String bannerText;

  factory MyBanner.fromJson(Map<String, dynamic> json) => MyBanner(
    bannerImgId: json["bannerImgId"],
    bannerImgUrl: json["bannerImgUrl"],
    categoryId: json["categoryId"],
    bannerText: json["bannerText"],
  );

  Map<String, dynamic> toJson() => {
    "bannerImgId": bannerImgId,
    "bannerImgUrl": bannerImgUrl,
    "categoryId": categoryId,
    "bannerText": bannerText,
  };
}
