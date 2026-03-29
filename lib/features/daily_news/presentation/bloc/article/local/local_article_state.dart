import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:equatable/equatable.dart';

abstract class LocalArticleState extends Equatable {
  final List<ArticleEntity> ? articles;

  const LocalArticleState({this.articles});

  @override
  List<Object?> get props => [articles];
}

class LocalArticleLoading extends LocalArticleState {
  const LocalArticleLoading() : super();
}

class LocalArticleLoaded extends LocalArticleState {
  const LocalArticleLoaded({required List<ArticleEntity> articles})
      : super(articles: articles);
}