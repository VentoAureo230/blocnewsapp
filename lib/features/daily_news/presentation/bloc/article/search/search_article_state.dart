import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class SearchArticleState extends Equatable {
  final List<ArticleEntity>? articles;
  final DioException? error;

  const SearchArticleState({this.articles, this.error});

  @override
  List<Object?> get props => [articles, error];
}

class SearchArticleInitial extends SearchArticleState {
  const SearchArticleInitial() : super();
}

class SearchArticleLoading extends SearchArticleState {
  const SearchArticleLoading() : super();
}

class SearchArticleLoaded extends SearchArticleState {
  const SearchArticleLoaded({required List<ArticleEntity> articles})
    : super(articles: articles);
}

class SearchArticleError extends SearchArticleState {
  const SearchArticleError(DioException error) : super(error: error);
}
