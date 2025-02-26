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
    String path = join(await getDatabasesPath(), 'profile.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE profile(id INTEGER PRIMARY KEY, imagePath TEXT)',
        );
      },
    );
  }

  Future<void> insertImagePath(String path) async {
    final db = await database;
    await db.insert('profile', {'id': 1, 'imagePath': path},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<String?> getImagePath() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('profile');

    if (maps.isNotEmpty) {
      return maps.first['imagePath'];
    }
    return null;
  }
}
