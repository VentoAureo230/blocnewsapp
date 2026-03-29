import 'package:blocnewsapp/core/usecases/usecase.dart';
import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:blocnewsapp/features/daily_news/domain/repository/article_repository.dart';

class RemoveArticleUseCase implements Usecase<void, ArticleEntity> {
  final ArticleRepository _articleRepository;

  RemoveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({ArticleEntity ? params}) {
    return _articleRepository.deleteArticle(params!);
  }
}