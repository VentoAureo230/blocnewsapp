import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:blocnewsapp/features/daily_news/data/models/article.dart';

part 'news_api_service.g.dart';

/// This file is responsible for handling all the networks call methods
/// Code is generated using the retrofit package
@RestApi()
abstract class NewsApiService {
  factory NewsApiService(Dio dio, {String? baseUrl}) = _NewsApiService;

  @GET("/daily-news/top-headlines")
  Future<HttpResponse<ArticlesModel>> getNewsArticles({
    @Query("country") String? country,
    @Query("category") String? category,
  });

  @GET("/daily-news/search")
  Future<HttpResponse<ArticlesModel>> searchArticles({
    @Query("query") String? query,
    @Query("sortBy") String? sortBy,
  });
}
