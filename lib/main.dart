import 'package:blocnewsapp/config/theme/app_themes.dart';
import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:blocnewsapp/features/daily_news/presentation/pages/article_detail/article_details.dart';
import 'package:blocnewsapp/features/daily_news/presentation/pages/home/daily_news.dart';
import 'package:blocnewsapp/features/daily_news/presentation/pages/saved_article/saved_article.dart';
import 'package:blocnewsapp/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticleBloc>(
      create: (context) => sl()..add(const GetArticles()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DailyNews(),
        theme: theme(),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/ArticleDetails':
              return MaterialPageRoute(
                builder: (_) => ArticleDetailsView(
                  article: settings.arguments as ArticleEntity?,
                ),
              );
            case '/SavedArticles':
              return MaterialPageRoute(
                builder: (_) => const SavedArticles(),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
