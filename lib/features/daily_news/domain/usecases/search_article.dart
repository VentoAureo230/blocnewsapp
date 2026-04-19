import 'package:blocnewsapp/core/usecases/usecase.dart';

import '../../../../core/resources/data_state.dart';
import '../entities/article.dart';
import '../repository/article_repository.dart';

class SearchArticleUseCase
    implements Usecase<DataState<List<ArticleEntity>>, String> {
  final ArticleRepository _articleRepository;
  SearchArticleUseCase(this._articleRepository);

  @override
  Future<DataState<List<ArticleEntity>>> call({String? params}) {
    return _articleRepository.searchArticles(params ?? '');
  }
}