import 'dart:io';

import 'package:blocnewsapp/core/util/api_error_handler.dart';
import 'package:blocnewsapp/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:dio/dio.dart';
import 'package:blocnewsapp/core/constants/constants.dart';
import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:blocnewsapp/features/daily_news/data/models/article.dart';
import 'package:blocnewsapp/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final ArticleDao _articleDao;
  final ApiErrorHandler _apiErrorHandler = const ApiErrorHandler();

  ArticleRepositoryImpl(this._newsApiService, this._articleDao);

  @override
  /// We return model in the data layer, not entity because the domain layer must not depend on other layers
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.articles);
      } else {
        return DataFailed(_apiErrorHandler.fromResponse(httpResponse.response));
      }
    } on DioException catch (e) {
      return DataFailed(_apiErrorHandler.handle(e));
    }
  }

  @override
  Future<void> deleteArticle(ArticleEntity article) {
    return _articleDao.deleteArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<List<ArticleModel>> getSavedArticle() {
    return _articleDao.getAllArticles();
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _articleDao.insertArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<DataState<List<ArticleEntity>>> searchArticles(String query) async {
    try {
      final httpResponse = await _newsApiService.searchArticles(
        query: query,
        sortBy: 'publishedAt',
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data.articles);
      } else {
        return DataFailed(_apiErrorHandler.fromResponse(httpResponse.response));
      }
    } on DioException catch (e) {
      return DataFailed(_apiErrorHandler.handle(e));
    }
  }
}
