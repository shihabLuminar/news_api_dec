import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:news_api_dec/model/home_screen_models/news_res_model.dart';

class SearchScreenController with ChangeNotifier {
  bool isLoading = false; // initially loading  the entire body

  // result
  List<Article> searchedArticlesResult = []; //

  searchNews({required String query}) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
        "https://newsapi.org/v2/everything?q=$query&apiKey=742488509a4f4f23b93e7ac3afc24cad");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decodedRes = jsonDecode(response.body);
      NewsResModel resModel = NewsResModel.fromJson(decodedRes);
      searchedArticlesResult = resModel.articles ?? [];
    }
    isLoading = false;
    notifyListeners();
  }
}
