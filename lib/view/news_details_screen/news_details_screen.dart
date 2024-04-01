// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_api_dec/model/home_screen_models/news_res_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key, required this.selectedArticle});
  final Article selectedArticle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
              Text(selectedArticle.title.toString()),
              SizedBox(height: 15),
              CachedNetworkImage(
                height: 300,
                fit: BoxFit.cover,
                imageUrl: selectedArticle.urlToImage.toString(),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              SizedBox(height: 20),
              Text(
                  textAlign: TextAlign.justify,
                  selectedArticle.content.toString()),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final url = Uri.parse(selectedArticle.url.toString());
                    await launchUrl(url);
                  },
                  child: Text("Read More")),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
