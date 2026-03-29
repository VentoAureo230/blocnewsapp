import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE article(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            author TEXT,
            title TEXT,
            description TEXT,
            url TEXT,
            urlToImage TEXT,
            publishedAt TEXT,
            content TEXT
          )
        ''');
      },
    );
  }
}