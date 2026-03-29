import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

// import 'package:blocnewsapp/core/constants/constants.dart';
import 'package:blocnewsapp/features/daily_news/data/models/article.dart';

part 'news_api_service.g.dart';

/// This file is responsible for handling all the networks call methods
/// Code is generated using the retrofit package
@RestApi(baseUrl: "https://newsapi.org/v2") // Passing data from .env file is not working, so I hardcoded the base url here
abstract class NewsApiService {
  factory NewsApiService(Dio dio) = _NewsApiService;

  @GET("/top-headlines")
  Future<HttpResponse<ArticlesModel>> getNewsArticles({
    @Query("apiKey") String ? apiKey,
    @Query("country") String ? country,
    @Query("category") String ? category,
  });
}