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

  Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'instadam.db'),
      onCreate: (db, version) {
        print("Creando tabla users...");
        return db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          username TEXT NOT NULL UNIQUE,
          password TEXT NOT NULL
        );
      ''');
      },
      onOpen: (db) async {
        print("Verificando si la tabla users existe...");
        var tableExists = await db.rawQuery(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='users'");
        if (tableExists.isEmpty) {
          print("La tabla users no existe, creándola...");
          await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL
          );
        ''');
          print("Tabla users creada exitosamente");
        } else {
          print("La tabla users ya existe");
        }
      },
      version: 1,
    );
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  Future<bool> checkUserExists(String email, String username) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'email = ? OR username = ?',
        whereArgs: [email, username],
      );
      return result.isNotEmpty;
    } catch (e) {
      print("Error en checkUserExists: $e");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUser(
      String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> insertLike(int postId, bool isLiked) async {
    final db = await database;
    await db.insert(
      'likes',
      {'postId': postId, 'isLiked': isLiked ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

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

  Future<List<Map<String, dynamic>>> getComments(int postId) async {
    final db = await database;
    return db.query(
      'comments',
      where: 'postId = ?',
      whereArgs: [postId],
    );
  }

  Future<void> insertComment(int postId, String content) async {
    final db = await database;
    await db.insert(
      'comments',
      {'postId': postId, 'content': content},
    );
  }

  Future<String> register(
      String name, String email, String username, String password) async {
    try {
      final userExists = await checkUserExists(email, username);

      if (userExists) {
        return "El correo electrónico o el nombre de usuario ya están en uso.";
      }

      await insertUser({
        'name': name,
        'email': email,
        'username': username,
        'password': password
      });

      return "Registro exitoso";
    } catch (e) {
      print("Error al registrar usuario: $e");
      return "Ocurrió un error durante el registro.";
    }
  }
}
