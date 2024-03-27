import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api_dec/model/home_screen_models/news_res_model.dart';

class HomeScreenController with ChangeNotifier {
  bool categoryLoading = false; // for laoding only category section
  bool isLoading = false; // initially loading  the entire body

  // result
  List<Article> articlesByCategory = []; // to store articles based of category
  List<Article> topheadlinesList =
      []; // to store articles based on top head lines
  static int selectdCategoryIndex = 0; // to show the selected category

//categories list
  static List<String> categoryList = [
    "business",
    "entertainment",
    "general",
    "health",
    "science",
    "sports",
    "technology"
  ];

  // news fetch

  // fetchNews() async {
  //   isLoading = true;
  //   notifyListeners();
  //   final url = Uri.parse(
  //       "https://newsapi.org/v2/everything?q=All&apiKey=742488509a4f4f23b93e7ac3afc24cad");

  //   final response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     final decodedRes = jsonDecode(response.body);
  //     NewsResModel resModel = NewsResModel.fromJson(decodedRes);
  //     articles = resModel.articles ?? [];
  //   }
  //   isLoading = false;
  //   notifyListeners();
  // }

// to fetch news based on category
  fetchNewsbyCategory({String category = "business", int index = 0}) async {
    selectdCategoryIndex = index;
    notifyListeners();
    categoryLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=742488509a4f4f23b93e7ac3afc24cad");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedRes = jsonDecode(response.body);
      NewsResModel resModel = NewsResModel.fromJson(decodedRes);
      articlesByCategory = resModel.articles ?? [];
    }
    categoryLoading = false;
    notifyListeners();
  }
// to fetch to headlines

  getTopHeadlines() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/top-headlines?country=in&apiKey=742488509a4f4f23b93e7ac3afc24cad");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedRes = jsonDecode(response.body);
      NewsResModel resModel = NewsResModel.fromJson(decodedRes);
      topheadlinesList = resModel.articles ?? [];
    }
    isLoading = false;
    notifyListeners();
  }
}
