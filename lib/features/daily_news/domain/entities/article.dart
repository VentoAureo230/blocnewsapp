import 'package:equatable/equatable.dart';

/// This class represents the article entity in our application.
/// It contains all the necessary fields that we need to display the article information in our UI.
/// It also extends Equatable to make it easier to compare instances of this class.
class ArticleEntity extends Equatable {
  final int ? id;
  final String ? author;
  final String ? title;
  final String ? description;
  final String ? url;
  final String ? urlToImage;
  final String ? publishedAt;
  final String ? content;

  const ArticleEntity({
    this.id,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  /// Props decide which object we should consider for equality comparison
  /// Returns list of objects
  @override
  List<Object?> get props => [
        id,
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      ];
}
