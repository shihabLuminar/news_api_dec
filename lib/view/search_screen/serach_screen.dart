// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_api_dec/controller/search_screen_controller.dart';
import 'package:news_api_dec/view/globla_widgets/custom_news_card.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    // Provider.of<SearchScreenController>(context, listen: false).cleardata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final proObj = Provider.of<SearchScreenController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                    fillColor: Colors.lightBlue.shade100,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    suffixIcon: InkWell(
                        onTap: () {
                          if (searchController.text.isNotEmpty) {
                            Provider.of<SearchScreenController>(context,
                                    listen: false)
                                .searchNews(query: searchController.text);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(20))),
                          child: Icon(Icons.search),
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none)),
                onChanged: (value) {
                  if (searchController.text.length > 3) {
                    Provider.of<SearchScreenController>(context, listen: false)
                        .searchNews(query: searchController.text);
                  }
                },
              ),
            ),
            Expanded(
                child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: proObj.searchedArticlesResult.length,
              itemBuilder: (context, index) => CustomNewsCard(
                  imageUrl:
                      proObj.searchedArticlesResult[index].urlToImage ?? "",
                  category:
                      proObj.searchedArticlesResult[index].source?.name ?? "",
                  title: proObj.searchedArticlesResult[index].title ?? "",
                  author: proObj.searchedArticlesResult[index].author ?? "",
                  dateTime: proObj.searchedArticlesResult[index].publishedAt !=
                          null
                      ? DateFormat('dd MMM yyyy').format(
                          proObj.searchedArticlesResult[index].publishedAt!)
                      : ""),
              separatorBuilder: (context, index) => Divider(
                thickness: .5,
                indent: 30,
                endIndent: 30,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
