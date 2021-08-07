class MySize {
  MySize({
    required this.sizeId,
    required this.sizeName,
    required this.productSizes,
  });

  int sizeId;
  String sizeName;
  List<dynamic> productSizes;

  factory MySize.fromJson(Map<String, dynamic> json) => MySize(
    sizeId: json["sizeId"],
    sizeName: json["sizeName"],
    productSizes: List<dynamic>.from(json["productSizes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sizeId": sizeId,
    "sizeName": sizeName,
    "productSizes": List<dynamic>.from(productSizes.map((x) => x)),
  };
}