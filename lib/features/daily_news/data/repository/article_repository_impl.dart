import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/daily_news/data/models/article.dart';
import 'package:blocnewsapp/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() {
    // TODO: implement getNewsArticles
    throw UnimplementedError();
  }
}