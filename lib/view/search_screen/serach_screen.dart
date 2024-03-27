import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_api_dec/controller/search_screen_controller.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final proObj = Provider.of<SearchScreenController>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  suffixIcon: InkWell(
                      onTap: () {
                        if (searchController.text.isNotEmpty) {
                          Provider.of<SearchScreenController>(context,
                                  listen: false)
                              .searchNews(query: searchController.text);
                        }
                      },
                      child: Icon(Icons.search))),
              onChanged: (value) {
                if (searchController.text.length > 3) {
                  print("api called");
                  Provider.of<SearchScreenController>(context, listen: false)
                      .searchNews(query: searchController.text);
                }
              },
            ),
            Expanded(
                child: ListView.builder(
              itemCount: proObj.searchedArticlesResult.length,
              itemBuilder: (context, index) =>
                  Text(proObj.searchedArticlesResult[index].title.toString()),
            ))
          ],
        ),
      ),
    );
  }
}
