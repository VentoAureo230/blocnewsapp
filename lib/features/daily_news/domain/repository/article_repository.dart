import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  Future<List<ArticleEntity>> getSavedArticle();

  Future<void> saveArticle(ArticleEntity article);

  Future<void> deleteArticle(ArticleEntity article);
}