import 'package:blocnewsapp/features/daily_news/data/data_sources/local/DAO/article_dao.dart';
import 'package:blocnewsapp/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:blocnewsapp/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:blocnewsapp/features/daily_news/domain/repository/article_repository.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/get_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/remove_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/save_article.dart';
import 'package:blocnewsapp/features/daily_news/domain/usecases/search_article.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/search/search_article_bloc.dart';
import 'package:blocnewsapp/features/weather/data/data_sources/remote/weather_api_service.dart';
import 'package:blocnewsapp/features/weather/data/repository/weather_repository_impl.dart';
import 'package:blocnewsapp/features/weather/domain/repository/weather_repository.dart';
import 'package:blocnewsapp/features/weather/domain/usecases/get_weather.dart';
import 'package:blocnewsapp/features/weather/presentation/cubit/weather_cubit.dart';
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
  sl.registerSingleton<WeatherApiService>(WeatherApiService(sl()));
  sl.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(sl())
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

  sl.registerSingleton<SearchArticleUseCase>(
    SearchArticleUseCase(sl())
  );

  sl.registerSingleton<GetWeatherUseCase>(
    GetWeatherUseCase(sl())
  );

  // BLoCs
  sl.registerFactory<RemoteArticleBloc>(
    () => RemoteArticleBloc(sl())
  );

  sl.registerFactory<LocalArticleBloc>(
    () => LocalArticleBloc(sl(), sl(), sl())
  );

  sl.registerFactory<SearchArticleBloc>(
    () => SearchArticleBloc(sl())
  );

  sl.registerFactory<WeatherCubit>(
    () => WeatherCubit(sl())
  );
}