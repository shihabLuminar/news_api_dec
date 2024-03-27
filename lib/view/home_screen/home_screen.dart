// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:news_api_dec/controller/home_screen_controller.dart';
import 'package:news_api_dec/view/home_screen/widgets/custom_news_card.dart';
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
      await Provider.of<HomeScreenController>(context, listen: false)
          .fetchNewsbyCategory();
      await Provider.of<HomeScreenController>(context, listen: false)
          .getTopHeadlines();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerObj = Provider.of<HomeScreenController>(context);
    return DefaultTabController(
      length: 4,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              CarouselSlider(
                  options: CarouselOptions(height: 400.0),
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
                          ))),
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
                            HomeScreenController.selectdCategoryIndex == index
                                ? Colors.grey
                                : null),
                        label: Text(HomeScreenController.categoryList[index]
                            .toUpperCase()),
                      ),
                    ),
                  ),
                )),
              ),
              Expanded(
                child: providerObj.categoryLoading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.separated(
                        itemCount: providerObj.articlesByCategory.length,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        itemBuilder: (context, index) => CustomNewsCard(
                            imageUrl:
                                providerObj.articlesByCategory[index].urlToImage ??
                                    "",
                            author: providerObj.articlesByCategory[index].author ??
                                "",
                            category: providerObj
                                    .articlesByCategory[index].source?.name ??
                                "",
                            title: providerObj.articlesByCategory[index].title ??
                                "",
                            dateTime: providerObj.articlesByCategory[index]
                                        .publishedAt !=
                                    null
                                ? DateFormat("dd MMM yyyy ").format(
                                    providerObj.articlesByCategory[index].publishedAt!)
                                : ""),
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
      ),
    );
  }
}
