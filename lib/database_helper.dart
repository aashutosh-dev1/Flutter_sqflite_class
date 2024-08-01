import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const databaseName = "todo_database.db";
  static const todoTable = "todos";
  DatabaseHelper();

  Future<Database> _initDatabase() async {
    // Open the database and store the reference.
    String path = await getDatabasesPath();
    return openDatabase(join(path, databaseName), onCreate: (db, version) {
      return db.execute('''
           CREATE TABLE $todoTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            isCompleted BOOLEAN NOT NULL DEFAULT 0
           )
            ''');
    }, version: 1);
  }

  Future<int> insertTodo(
    String title,
  ) async {
    final db = await _initDatabase();
    final insertedValues = await db.insert(
      todoTable,
      {
        "title": title,
      },
    );
    print("WHILE INSERTING $insertedValues");
    return insertedValues;
  }

  Future<List<Map<String, dynamic>>> getTodos() async {
    final db = await _initDatabase();
    final data = await db.query(todoTable);
    print("DATA $data");
    return data;
  }
}
