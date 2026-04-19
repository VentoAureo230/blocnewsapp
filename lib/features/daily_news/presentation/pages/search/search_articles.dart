import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/search/search_article_bloc.dart';
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/search/search_article_event.dart'
  as search_event;
import 'package:blocnewsapp/features/daily_news/presentation/bloc/article/search/search_article_state.dart';
import 'package:blocnewsapp/features/daily_news/presentation/widget/article_widget.dart';
import 'package:blocnewsapp/injection_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchArticles extends StatelessWidget {
  const SearchArticles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchArticleBloc>(),
      child: const _SearchArticlesView(),
    );
  }
}

class _SearchArticlesView extends StatelessWidget {
  const _SearchArticlesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search', style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: TextField(
              onChanged: (query) {
                context
                    .read<SearchArticleBloc>()
                    .add(search_event.SearchArticles(query));
              },
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Search articles by keyword',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchArticleBloc, SearchArticleState>(
              builder: (context, state) {
                if (state is SearchArticleLoading) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                if (state is SearchArticleError) {
                  return Center(
                    child: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                  );
                }

                if (state is SearchArticleLoaded) {
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

                return const Center(
                  child: Text('Search for articles by keyword'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onArticlePressed(BuildContext context, ArticleEntity article) {
    Navigator.pushNamed(context, '/ArticleDetails', arguments: article);
  }
}