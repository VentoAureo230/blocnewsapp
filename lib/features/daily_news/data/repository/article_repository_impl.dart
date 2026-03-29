import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/daily_news/data/models/article.dart';
import 'package:blocnewsapp/features/daily_news/domain/repository/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {

  @override
  /// We return model in the data layer, not entity because the domain layer must not depend on other layers
  Future<DataState<List<ArticleModel>>> getNewsArticles() {
    // TODO: implement getNewsArticles
    throw UnimplementedError();
  }
}