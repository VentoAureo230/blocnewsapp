import 'package:equatable/equatable.dart';

abstract class SearchArticleEvent extends Equatable {
  const SearchArticleEvent();

  @override
  List<Object?> get props => [];
}

class SearchArticles extends SearchArticleEvent {
  final String query;

  const SearchArticles(this.query);

  @override
  List<Object?> get props => [query];
}