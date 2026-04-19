import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/search_article.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import 'search_article_event.dart';
import 'search_article_state.dart';

class SearchArticleBloc extends Bloc<SearchArticleEvent, SearchArticleState> {
  final SearchArticleUseCase _searchArticleUseCase;

  SearchArticleBloc(this._searchArticleUseCase)
    : super(const SearchArticleInitial()) {
    on<SearchArticles>(
      onSearchArticles,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  void onSearchArticles(
    SearchArticles event,
    Emitter<SearchArticleState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchArticleInitial());
      return;
    }

    emit(const SearchArticleLoading());
    final dataState = await _searchArticleUseCase(params: query);

    if (dataState is DataSuccess && dataState.data!.isNotEmpty) {
      emit(SearchArticleLoaded(articles: dataState.data!));
    } else if (dataState is DataFailed) {
      emit(SearchArticleError(dataState.error!));
    } else {
      emit(const SearchArticleInitial());
    }
  }
}
