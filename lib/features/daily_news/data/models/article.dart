import 'package:blocnewsapp/features/daily_news/domain/entities/article.dart';

/// We use a model and not Entity because the domain layer must not depend on other layers
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.id,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> map) {
    return ArticleModel(
      author: map['author'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      url: map['url'] as String?,
      urlToImage: map['urlToImage'] as String?,
      publishedAt: map['publishedAt'] as String?,
      content: map['content'] as String?,
    );
  }
}

/// Wrapper for the response of the news api. The top key is "articles" and it contains a list of articles
class ArticlesModel {
  final List<ArticleModel> articles;

  const ArticlesModel({required this.articles});

  factory ArticlesModel.fromJson(Map<String, dynamic> map) {
    return ArticlesModel(
      articles: (map['articles'] as List<dynamic>)
          .map((i) => ArticleModel.fromJson(i))
          .toList(),
    );
  }
}
