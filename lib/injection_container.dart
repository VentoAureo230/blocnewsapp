import 'package:blocnewsapp/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import 'package:blocnewsapp/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:blocnewsapp/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:blocnewsapp/features/daily_news/domain/repository/article_repository.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/get_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/remove_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/save_article.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final sl = GetIt.instance;
/// get_it allows to decouple the creation & consumption of dependencies
/// and retrieve them from anywhere else, avoiding nested calls
/// i.e "HomeScreen(api: Api(client: Client(foo: Foo)))"
Future<void> initDependencies() async {

  // Dio
  sl.registerSingleton<Dio>(Dio());
  // Dependencies
  sl.registerSingleton<ArticleDao>(ArticleDao());
  sl.registerSingleton<NewsApiService>(NewsApiService(sl()));
  sl.registerSingleton<ArticleRepository>(
    ArticleRepositoryImpl(sl(), sl())
  );

  // Usecases
  sl.registerSingleton<GetArticleUseCase>(
    GetArticleUseCase(sl())
  );

  sl.registerSingleton<RemoveArticleUseCase>(
    RemoveArticleUseCase(sl())
  );

  sl.registerSingleton<SaveArticleUseCase>(
    SaveArticleUseCase(sl())
  );

  sl.registerSingleton<GetSavedArticleUseCase>(
    GetSavedArticleUseCase(sl())
  );

  // BLoCs
  sl.registerFactory<RemoteArticleBloc>(
    () => RemoteArticleBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    () => LocalArticleBloc(sl(), sl(), sl())
  );
}