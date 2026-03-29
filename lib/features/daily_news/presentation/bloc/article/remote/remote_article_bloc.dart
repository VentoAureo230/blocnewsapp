import 'package:blocnewsapp/core/resources/data_state.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/get_article.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemoteArticleBloc extends Bloc<RemoteArticlesEvent, RemoteArticleState> {
  final GetArticleUseCase _getArticleUseCase;
  RemoteArticleBloc(this._getArticleUseCase)
    : super(const RemoteArticleLoading()) {
    on<GetArticles>(onGetArticles);
  }

  void onGetArticles(
    GetArticles event,
    Emitter<RemoteArticleState> emit,
  ) async {
    final dataState = await _getArticleUseCase();

    if (dataState is DataSuccess && dataState.data!.isEmpty) {
      emit(RemoteArticleLoaded(articles: dataState.data!));
    }

    if (dataState is DataFailed) {
      emit(RemoteArticleError(dataState.error!));
    }
  }
}
