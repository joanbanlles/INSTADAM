import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'instadam.db'),
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE comments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            postId INTEGER NOT NULL,
            content TEXT NOT NULL
          );
        ''');

        db.execute('''
          CREATE TABLE likes (
            postId INTEGER PRIMARY KEY,
            isLiked INTEGER NOT NULL
          );
        ''');
      },
      version: 1,
    );
  }

  // Inserta o actualiza el estado del like
  Future<void> insertLike(int postId, bool isLiked) async {
    final db = await database;
    await db.insert(
      'likes',
      {'postId': postId, 'isLiked': isLiked ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Verifica si un post está marcado como like
  Future<bool> isPostLiked(int postId) async {
    final db = await database;
    final result = await db.query(
      'likes',
      where: 'postId = ?',
      whereArgs: [postId],
    );
    if (result.isNotEmpty) {
      return result.first['isLiked'] == 1;
    }
    return false;
  }

  // Obtiene los comentarios de un post
  Future<List<Map<String, dynamic>>> getComments(int postId) async {
    final db = await database;
    return db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
    );
  }

  // Inserta un comentario en un post
  Future<void> insertComment(int postId, String content) async {
    final db = await database;
    await db.insert(
      'comments',
      {'postId': postId, 'content': content},
    );
  }
}
