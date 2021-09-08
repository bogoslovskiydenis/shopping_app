
class FeatureImg {
  int featureImgId;
  String featureImgUrl;
  Null categoryId;

  FeatureImg({ this.featureImgId,  this.featureImgUrl, this.categoryId});

factory  FeatureImg.fromJson(Map<String, dynamic> json)=> FeatureImg(
    featureImgId : json['featureImgId'],
    featureImgUrl : json['featureImgUrl'],
    categoryId : json['categoryId']
);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['featureImgId'] = this.featureImgId;
    data['featureImgUrl'] = this.featureImgUrl;
    data['categoryId'] = this.categoryId;
    return data;
  }
}