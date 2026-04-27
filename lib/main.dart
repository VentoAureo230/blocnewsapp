import 'package:blocnewsapp/config/routes/app_router.dart';
import 'package:blocnewsapp/config/theme/app_themes.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:blocnewsapp/features/authentication/presentation/widget/authentication_gate.dart';
import 'package:blocnewsapp/features/weather/presentation/cubit/weather_cubit.dart';
import 'package:blocnewsapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RemoteArticleBloc>(
          create: (context) => sl()..add(const GetArticles()),
        ),
        BlocProvider<WeatherCubit>(
          create: (context) => sl()..getWeather('Rennes'),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthenticationGate(),
        theme: theme(),
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}
