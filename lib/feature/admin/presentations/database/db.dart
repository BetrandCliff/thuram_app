import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
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
              comments TEXT NOT NULL,
              likes TEXT NOT NULL,
              profilePic TEXT NOT NULL,
              name TEXT NOT NULL,
              message TEXT NOT NULL,
              mediaPath TEXT NOT NULL,
              thumbnailPath TEXT NOT NULL,
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
  // Future<void> insertPost(String table, Map<String, dynamic> postData) async {
  //   final db = await database;
  //   await db.insert(table, postData, conflictAlgorithm: ConflictAlgorithm.replace);
  // }
  Future<void> insertPost(String table, Map<String, dynamic> postData) async {
    final db = await database;

    // ✅ Ensure `id` exists
    if (!postData.containsKey('id') || postData['id'] == null) {
      throw Exception("Error: Missing `id` in post data");
    }

    // ✅ Convert comments & likes to JSON strings before storing
    postData['comments'] = jsonEncode(postData['comments'] ?? []);
    postData['likes'] = jsonEncode(postData['likes'] ?? []);

    await db.insert(table, postData, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // New function for inserting an academic post (ensures createdAt is included)
  Future<void> insertAcademicPost(Map<String, dynamic> postData) async {
    final db = await database;

    // ✅ Ensure `id` exists
    if (!postData.containsKey('id') || postData['id'] == null) {
      throw Exception("Error: Missing `id` in post data");
    }

    // ✅ Convert comments & likes to JSON before inserting
    postData['comments'] = jsonEncode(postData['comments'] ?? []);
    postData['likes'] = jsonEncode(postData['likes'] ?? []);

    // ✅ Convert `createdAt` from Firebase Timestamp to String (if necessary)
    if (postData['createdAt'] is Timestamp) {
      postData['createdAt'] = (postData['createdAt'] as Timestamp).toDate().toString();
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
    List<Map<String, dynamic>> posts = await db.query('academy_posts');
print("\n\ndatabase cache post $post(url)");
    return posts.map((post) {
      return {
        ...post,
        'comments': jsonDecode(post['comments']), // Convert JSON string back to a list
        'likes': jsonDecode(post['likes']),       // Convert JSON string back to a list
      };
    }).toList();
  }


  Future<void> deletePost(String table, String postId) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [postId]);
  }
}
