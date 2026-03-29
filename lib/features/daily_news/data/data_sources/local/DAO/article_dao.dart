import 'package:blocnewsapp/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:blocnewsapp/features/daily_news/data/models/article.dart';

class ArticleDao {
  Future<void> insertArticle(ArticleModel article) async {
    final db = await AppDatabase.database;
    await db.insert('article', article.toMap());
  }

  Future<void> deleteArticle(ArticleModel article) async {
    final db = await AppDatabase.database;
    await db.delete('article', where: 'id = ?', whereArgs: [article.id]);
  }

  Future<List<ArticleModel>> getAllArticles() async {
    final db = await AppDatabase.database;
    final maps = await db.query('article');
    return maps.map((map) => ArticleModel.fromMap(map)).toList();
  }
}