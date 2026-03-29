import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/local/local_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/local/local_article_event.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:blocnewsapp/features/daily_news/presentation/widget/article_widget.dart';
import 'package:blocnewsapp/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedArticles extends StatelessWidget {
  const SavedArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(const GetSavedArticles()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Saved Articles', style: TextStyle(color: Colors.black)),
      leading: Builder(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left, color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LocalArticleBloc, LocalArticleState>(
      builder: (context, state) {
        if (state is LocalArticleLoading) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (state is LocalArticleLoaded) {
          if (state.articles!.isEmpty) {
            return const Center(
              child: Text('No saved articles yet'),
            );
          }
          return ListView.builder(
            itemCount: state.articles!.length,
            itemBuilder: (context, index) {
              final article = state.articles![index];
              return Dismissible(
                key: ValueKey(article.id ?? index),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  BlocProvider.of<LocalArticleBloc>(context)
                      .add(RemoveArticle(article));
                },
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/ArticleDetails',
                    arguments: article,
                  ),
                  child: ArticleWidget(article: article),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
