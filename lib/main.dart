import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_app/model/category.dart';

import 'network/api_request.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //ignore: top_level_function_literal_block
  final _fetchCategories = FutureProvider((ref) async {
    var result = await fetchCategories();
    return result;
  });

  @override
  Widget build(BuildContext context,
      T Function<T>(ProviderBase<Object, T> provider) watch) {
    var bannerApiResult = watch(_fetchBanner);
    var featureImgApiResult = watch(_fetchFeatureImg);
    var categoriesApiResult = watch(_fetchCategories);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(child: categoriesApiResult.when(data: (categories)=> ListView.builder(itemCount: categories.length,
          itemBuilder: (context,index){
        return Card(child: Padding(padding: const EdgeInsets.all(8),
          child: ExpansionTile(
            title: Row(children: [
              CircleAvatar(backgroundImage: NetworkImage(categories[index].categoryImg),),
              SizedBox(width: 30,),
              categories[index].categoryName.length <=10 ?
                  Text(categories[index].categoryName):
                  Text(categories[index].categoryName, style: TextStyle(fontSize: 12),)
            ],),
            children: _buildList(categories[index]),
          ),
        ),
        );
          },
      ),
        loading: () => const Center(child: CircularProgressIndicator(),),
        error: (error, stack) => Center(
          child: Text('$error'),
    ),),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Drawer button

            //Feature
            featureImgApiResult.when(
                data: (featureImages) => Stack(
                  children: [
                    CarouselSlider(
                      items: featureImages
                          .map((e) => Builder(
                        builder: (context) => Container(
                          child: Image(
                            image: NetworkImage(e.featureImgUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
                          .toList(),
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          initialPage: 0,
                          viewportFraction: 1),
                    ),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [ IconButton(icon: Icon(Icons.menu,color: Colors.black,), onPressed: ()=> _scaffoldKey.currentState.openDrawer()
                     ),
                     SizedBox(height: 50,),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Icon(
                           Icons.navigate_before,
                           size: 45,
                           color: Colors.white,
                         ),
                         Icon(
                           Icons.navigate_next,
                           size: 45,
                           color: Colors.white,
                         ),
                       ],
                     )],)
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stack) => Center(
                  child: Text('$error'),
                )
        ,),
          Expanded(
            child: bannerApiResult.when(
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (error, stack) => Center(
                      child: Text('$error'),
                    ),
                data: (bannerImages) => ListView.builder(
                    itemCount: bannerImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image(
                                image: NetworkImage(
                                    bannerImages[index].bannerImgUrl),
                                fit: BoxFit.cover),
                            Container(
                              color: Color(0xFFFFFF),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  bannerImages[index].bannerText,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    })),
          )
        ],
      ),
    );
  }

  _buildList(MyCategory category) {
    var list = new List<Widget>();
    category.subCategories.forEach((element) {
      list.add(Padding(padding: const EdgeInsets.all(8),
      child: Text(element.subCategoryName,
      style: TextStyle(fontSize: 12),),));
    });
    return list;
  }
}


