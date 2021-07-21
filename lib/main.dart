import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'network/api_request.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {

  //ignore: top_level_function_literal_block
  final _fetchBanner = FutureProvider((ref) async {
    var result = await fetchBanner();
    return result;
  });

  //ignore: top_level_function_literal_block
  final _fetchFeatureImg = FutureProvider((ref) async {
    var result = await fetchFeatureImages();
    return result;
  });


  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var bannerApiResult = watch(_fetchBanner);
    var featureImgApiResult = watch(_fetchFeatureImg);


    return Scaffold(
      body: Column(children: [
        featureImgApiResult.when(
            data: (featureImages) =>
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CarouselSlider(items: featureImages.map((e) =>
                        Builder(builder: (context) =>
                            Container(child: Image(
                              image: NetworkImage(e.featureImgUrl),
                              fit: BoxFit.cover,),),)).toList(),
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        initialPage: 0,
                        viewportFraction: 1
                      ),
                    ),
                    Row(crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.navigate_before,size: 45,color: Colors.white,),
                      Icon(Icons.navigate_next,size: 45,color: Colors.white,),
                    ],)
                  ],
                ),
          loading: ()=> const Center(child: CircularProgressIndicator(),) ,
          error: (error,stack) => Center(child: Text('$error'),)
        )
      ],),
    );
  }
}
