import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


/*
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
        // Table for media uploads (general media)
        await db.execute(
          '''CREATE TABLE media(
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                mediaPath TEXT NOT NULL, 
                mediaType TEXT NOT NULL, 
                status TEXT NOT NULL
            )''',
        );

        // Table for confessions
        await db.execute(
          '''CREATE TABLE confessions(
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                message TEXT NOT NULL, 
                mediaPath TEXT, 
                mediaType TEXT, 
                createdAt TEXT DEFAULT CURRENT_TIMESTAMP, 
                status TEXT NOT NULL
            )''',
        );

        
      },
    );
  }

  // Insert media (image or video) before uploading
  Future<void> insertMediaPath(String mediaPath, String mediaType, {String status = 'pending'}) async {
    final db = await database;
    await db.insert(
      'media',
      {
        'mediaPath': mediaPath,
        'mediaType': mediaType, 
        'status': status
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get pending media (not yet uploaded)
  Future<List<Map<String, dynamic>>> getPendingMedia() async {
    final db = await database;
    return await db.query('media', where: 'status = ?', whereArgs: ['pending']);
  }

  // Update media status (e.g., uploaded/failed)
  Future<void> updateMediaStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'media',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete media after successful upload
  Future<void> deleteMedia(int id) async {
    final db = await database;
    await db.delete('media', where: 'id = ?', whereArgs: [id]);
  }

  // Insert confession before uploading
  Future<void> insertConfession(String message, {String? mediaPath, String? mediaType, String status = 'pending'}) async {
    final db = await database;
    await db.insert(
      'confessions',
      {
        'message': message,
        'mediaPath': mediaPath,
        'mediaType': mediaType,
        'status': status
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get pending confessions (not yet uploaded)
  Future<List<Map<String, dynamic>>> getPendingConfessions() async {
    final db = await database;
    return await db.query('confessions', where: 'status = ?', whereArgs: ['pending']);
  }

  // Update confession status (e.g., uploaded/failed)
  Future<void> updateConfessionStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'confessions',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete confession after successful upload
  Future<void> deleteConfession(int id) async {
    final db = await database;
    await db.delete('confessions', where: 'id = ?', whereArgs: [id]);
  }
}

*/



/*
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
    String path = join(await getDatabasesPath(), 'media.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE media(
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                mediaPath TEXT NOT NULL, 
                mediaType TEXT NOT NULL, 
                status TEXT NOT NULL
            )''',
        );
      },
    );
  }

  // Insert media path with type (image/video) and status
  Future<void> insertMediaPath(String mediaPath, String mediaType, {String status = 'pending'}) async {
    final db = await database;
    await db.insert(
      'media',
      {
        'mediaPath': mediaPath,
        'mediaType': mediaType, 
        'status': status
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all pending media (not yet uploaded)
  Future<List<Map<String, dynamic>>> getPendingMedia() async {
    final db = await database;
    return await db.query('media', where: 'status = ?', whereArgs: ['pending']);
  }

  // Update media status (e.g., 'uploaded' or 'failed')
  Future<void> updateMediaStatus(int id, String status) async {
    final db = await database;
    await db.update(
      'media',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete media entry (after successful upload)
  Future<void> deleteMedia(int id) async {
    final db = await database;
    await db.delete('media', where: 'id = ?', whereArgs: [id]);
  }
}

*/


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
        // Tables to store only image or video paths
        await db.execute('''CREATE TABLE confessions(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');

        await db.execute('''CREATE TABLE lost_items(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');

        await db.execute('''CREATE TABLE club_posts(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');

        await db.execute('''CREATE TABLE profiles(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');

        await db.execute('''CREATE TABLE courses(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');

        await db.execute('''CREATE TABLE staff(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');

        await db.execute('''CREATE TABLE coursedetails(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              mediaPath TEXT NOT NULL,
              mediaType TEXT NOT NULL
          )''');
      },
    );
  }

  // Insert media (image or video) into a specific table
  Future<int> insertMedia(String table, String mediaPath, String mediaType) async {
    final db = await database;
    return await db.insert(
      table,
      {'mediaPath': mediaPath, 'mediaType': mediaType},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all stored media paths from a specific table
  Future<List<Map<String, dynamic>>> getMedia(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Delete media by ID after successful Firebase upload
  Future<void> deleteMedia(String table, int id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
