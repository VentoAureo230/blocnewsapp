import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:blocnewsapp/features/authentication/presentation/widget/authentication_gate.dart';
import 'package:blocnewsapp/features/daily_news/presentation/pages/article_detail/article_details.dart';
import 'package:blocnewsapp/features/daily_news/presentation/pages/saved_article/saved_article.dart';
import 'package:blocnewsapp/features/daily_news/presentation/pages/search/search_articles.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/Home':
        return MaterialPageRoute(
          builder: (_) => const AuthenticationGate(),
        );
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
      case '/SearchArticles':
        return MaterialPageRoute(
          builder: (_) => const SearchArticles(),
        );
      default:
        return null;
    }
  }
}
