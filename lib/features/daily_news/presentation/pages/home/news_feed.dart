import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/remote/remote_article_state.dart';
import 'package:blocnewsapp/features/daily_news/presentation/widget/article_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/article.dart';

class NewsFeed extends StatelessWidget {
  const NewsFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  BlocBuilder<RemoteArticleBloc, RemoteArticleState> _buildBody() {
    return BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
      builder: (_, state) {
        if (state is RemoteArticleLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is RemoteArticleError) {
          return const Center(child: Icon(Icons.refresh));
        }
        if (state is RemoteArticleLoaded) {
          return ListView.builder(
            itemCount: state.articles!.length,
            itemBuilder: (context, index) {
              final article = state.articles![index];
              return GestureDetector(
                onTap: () => _onArticlePressed(context, article),
                child: ArticleWidget(article: article),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}
