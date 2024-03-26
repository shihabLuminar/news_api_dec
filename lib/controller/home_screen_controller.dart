import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_api_dec/model/home_screen_models/news_res_model.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoading = false;

  // result
  List<Article> articles = [];

  // news fetch

  fetchNews() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=All&apiKey=742488509a4f4f23b93e7ac3afc24cad");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedRes = jsonDecode(response.body);
      NewsResModel resModel = NewsResModel.fromJson(decodedRes);
      articles = resModel.articles ?? [];
    }
    isLoading = false;
    notifyListeners();
  }
}
