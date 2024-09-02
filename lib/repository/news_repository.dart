import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/category_news_model.dart';
import '../models/news_channel_headlines_model.dart';

class NewsRepository{

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String name) async{
    String url='https://newsapi.org/v2/top-headlines?sources=${name}&apiKey=cd89cfc802d2467688125a82f7f768cd';

    final response= await http.get(Uri.parse(url));

    if(response.statusCode==200){
      final body= jsonDecode(response.body);
      return  NewsChannelsHeadlinesModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String categoryName) async{
    String url='https://newsapi.org/v2/everything?q=${categoryName}&apiKey=cd89cfc802d2467688125a82f7f768cd';

    final response= await http.get(Uri.parse(url));
        if (kDebugMode) {
          print(response.body);
        }
    if(response.statusCode==200){
      final body= jsonDecode(response.body);
      return  CategoryNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }

}