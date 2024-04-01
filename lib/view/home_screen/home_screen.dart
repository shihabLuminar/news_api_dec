// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_api_dec/controller/home_screen_controller.dart';
import 'package:news_api_dec/controller/search_screen_controller.dart';
import 'package:news_api_dec/view/globla_widgets/custom_news_card.dart';
import 'package:news_api_dec/view/news_details_screen/news_details_screen.dart';
import 'package:news_api_dec/view/search_screen/serach_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<HomeScreenController>(context, listen: false)
          .getTopHeadlines();
      Provider.of<HomeScreenController>(context, listen: false)
          .fetchNewsbyCategory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<HomeScreenController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("News App"),
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
          actions: [
            // search button
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => SearchScreenController(),
                          child: SearchScreen(),
                        ),
                      ));
                },
                icon: Icon(
                  Icons.search_sharp,
                  size: 30,
                  color: Colors.black,
                ))
          ],
        ),
        body: providerObj.isLoading // for laoding the entire body
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  // #1 carousel slider seciton
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 300,
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInToLinear,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollDirection: Axis.horizontal,
                    ),
                    items: List.generate(
                        providerObj.topheadlinesList.length,
                        (index) => Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: providerObj
                                          .topheadlinesList[index].urlToImage ??
                                      "",
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            )),
                  ),
                  // #2 category listing seciton

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: List.generate(
                      HomeScreenController.categoryList.length,
                      (index) => InkWell(
                        onTap: () async {
                          await Provider.of<HomeScreenController>(context,
                                  listen: false)
                              .fetchNewsbyCategory(
                                  index: index,
                                  category:
                                      HomeScreenController.categoryList[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Chip(
                            color: MaterialStatePropertyAll(
                                HomeScreenController.selectdCategoryIndex ==
                                        index
                                    ? Colors.grey
                                    : null),
                            label: Text(HomeScreenController.categoryList[index]
                                .toUpperCase()),
                          ),
                        ),
                      ),
                    )),
                  ),

                  // #3 news section
                  Expanded(
                    child: providerObj.categoryLoading ==
                            true // to show loding while changing category
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.separated(
                            itemCount: providerObj.articlesByCategory.length,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            itemBuilder: (context, index) => CustomNewsCard(
                              imageUrl: providerObj
                                      .articlesByCategory[index].urlToImage ??
                                  "",
                              author: providerObj
                                      .articlesByCategory[index].author ??
                                  "",
                              category: providerObj
                                      .articlesByCategory[index].source?.name ??
                                  "",
                              title:
                                  providerObj.articlesByCategory[index].title ??
                                      "",
                              dateTime: providerObj.articlesByCategory[index]
                                          .publishedAt !=
                                      null
                                  ? DateFormat("dd MMM yyyy ").format(
                                      providerObj.articlesByCategory[index]
                                          .publishedAt!)
                                  : "",
                              onCardTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailsScreen(
                                        selectedArticle: providerObj
                                            .articlesByCategory[index],
                                      ),
                                    ));
                              },
                            ),
                            separatorBuilder: (context, index) => Divider(
                              thickness: .5,
                              indent: 30,
                              endIndent: 30,
                            ),
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
