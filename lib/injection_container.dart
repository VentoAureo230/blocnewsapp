import 'dart:io';

import 'package:blocnewsapp/features/authentication/data/data_sources/local/authentication_local_storage.dart';
import 'package:blocnewsapp/features/authentication/data/data_sources/remote/authentication_api_service.dart';
import 'package:blocnewsapp/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:blocnewsapp/core/util/jwt_auth_interceptor.dart';
import 'package:blocnewsapp/features/authentication/domain/repository/authentication_repository.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/get_stored_token.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/login.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/logout.dart';
import 'package:blocnewsapp/features/authentication/domain/usecases/register.dart';
import 'package:blocnewsapp/features/authentication/presentation/cubit/authentication_cubit.dart';
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
import 'package:blocnewsapp/core/constants/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final sl = GetIt.instance;

/// get_it allows to decouple the creation & consumption of dependencies
/// and retrieve them from anywhere else, avoiding nested calls
/// i.e "HomeScreen(api: Api(client: Client(foo: Foo)))"
Future<void> initDependencies() async {
  final backendBaseUrl = Platform.isAndroid ? apiUrlAndroid : apiUrlIos;

  // Dio
  sl.registerSingleton<Dio>(Dio());
  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // Authentication
  sl.registerSingleton<AuthenticationLocalStorage>(
    AuthenticationLocalStorage(sl()),
  );

  final authDio = Dio(BaseOptions(baseUrl: backendBaseUrl));
  authDio.interceptors.add(
    JwtAuthInterceptor(
      getToken: () => sl<AuthenticationLocalStorage>().getToken(),
      excludedPaths: const {
        '/authentication/login',
        '/authentication/register',
      },
    ),
  );
  sl.registerSingleton<AuthenticationApiService>(
    AuthenticationApiService(authDio),
  );
  sl.registerSingleton<AuthenticationRepository>(
    AuthenticationRepositoryImpl(sl(), sl()),
  );
  sl.registerSingleton<GetStoredTokenUseCase>(GetStoredTokenUseCase(sl()));
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl()));
  sl.registerSingleton<RegisterUseCase>(RegisterUseCase(sl()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl()));

  final newsDio = Dio(BaseOptions(baseUrl: backendBaseUrl));
  newsDio.interceptors.add(
    JwtAuthInterceptor(
      getToken: () => sl<AuthenticationLocalStorage>().getToken(),
    ),
  );

  // Dependencies
  sl.registerSingleton<ArticleDao>(ArticleDao());
  sl.registerSingleton<NewsApiService>(NewsApiService(newsDio));
  sl.registerSingleton<ArticleRepository>(ArticleRepositoryImpl(sl(), sl()));
  sl.registerSingleton<WeatherApiService>(WeatherApiService(sl()));
  sl.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(sl()));

  // Usecases
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));

  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));

  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));

  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));

  sl.registerSingleton<SearchArticleUseCase>(SearchArticleUseCase(sl()));

  sl.registerSingleton<GetWeatherUseCase>(GetWeatherUseCase(sl()));

  // BLoCs
  sl.registerFactory<RemoteArticleBloc>(() => RemoteArticleBloc(sl()));

  sl.registerFactory<LocalArticleBloc>(
    () => LocalArticleBloc(sl(), sl(), sl()),
  );

  sl.registerFactory<SearchArticleBloc>(() => SearchArticleBloc(sl()));

  sl.registerFactory<WeatherCubit>(() => WeatherCubit(sl()));

  sl.registerFactory<AuthenticationCubit>(
    () => AuthenticationCubit(sl(), sl(), sl()),
  );
}
