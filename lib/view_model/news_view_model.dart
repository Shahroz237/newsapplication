


import '../models/category_news_model.dart';
import '../models/news_channel_headlines_model.dart';
import '../repository/news_repository.dart';

class NewsViewModel{

  final _rep= NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelsHeadlinesApi(String name) async{
    final response=_rep.fetchNewsChannelsHeadlinesApi(name);
    return response;

  }

  Future<CategoryNewsModel> fetchCategoryNewsApi(String categoryName) async{
    final response=_rep.fetchCategoryNewsApi(categoryName);
    return response;

  }

}