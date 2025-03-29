import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'app_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE confessions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');
        await db.execute('''CREATE TABLE academy_posts(
              id TEXT PRIMARY KEY,
              message TEXT NOT NULL,
              mediaPath TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              userId TEXT NOT NULL
          )''');
        await db.execute('''CREATE TABLE clubPosts(
              id TEXT PRIMARY KEY,
              message TEXT NOT NULL,
              mediaPath TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              userId TEXT NOT NULL
          )''');
        await db.execute('''CREATE TABLE lost_found_posts(
              id TEXT PRIMARY KEY,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              userId TEXT NOT NULL,
              type TEXT NOT NULL
          )''');
        await db.execute('''CREATE TABLE events(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              mediaPath TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              userId TEXT NOT NULL
          )''');
        await db.execute('''CREATE TABLE marketplace_posts(
              id TEXT PRIMARY KEY,
              itemName TEXT NOT NULL,
              description TEXT NOT NULL,
              price TEXT NOT NULL,
              mediaPath TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              userId TEXT NOT NULL
          )''');
      },
    );
  }

  // Existing generic function for inserting posts (used by confessions, lost items, club posts, etc.)
  Future<void> insertPost(String table, Map<String, dynamic> postData) async {
    final db = await database;
    await db.insert(table, postData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // New function for inserting an academic post (ensures createdAt is included)
  Future<void> insertAcademicPost(Map<String, dynamic> postData) async {
    final db = await database;
    // Make sure createdAt is provided; if not, default to current timestamp.
    if (postData['createdAt'] == null) {
      postData['createdAt'] = DateTime.now().toString();
    }
    await db.insert('academy_posts', postData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Existing generic function for retrieving cached posts
  Future<List<Map<String, dynamic>>> getCachedPosts(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // New function for getting cached academic posts
  Future<List<Map<String, dynamic>>> getCachedAcademicPosts() async {
    final db = await database;
    return await db.query('academy_posts');
  }

  Future<void> deletePost(String table, String postId) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [postId]);
  }
}
