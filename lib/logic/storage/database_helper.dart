import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// singleton class to manage Database
class DatabaseHelper {
  static final String _databaseName = 'ExerciseInstanceDatabase.db';
  static final int _databaseVersion = 1;
  static Database _database;

  // makes class into a singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only allows on connection to the database (if statement does it)
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // opens up Database connection
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE daysOfSplit (
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE exercises (
                id INTEGER PRIMARY KEY,
                idOfDay INTEGER NOT NULL,
                name TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE exerciseSessions (
                id INTEGER PRIMARY KEY,
                idOfExercise INTEGER NOT NULL,
                date TEXT NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE exerciseInstances (
                id INTEGER PRIMARY KEY,
                idOfExerciseSession INTEGER NOT NULL,
                weight FLOAT NOT NULL,
                strengthValue FLOAT NOT NULL,
                reps INTEGER NOT NULL
              )
              ''');
  }

  Future<void> clearDB() async {
    Database db = await database;
    db.delete('daysOfSplit');
    db.delete('exercises');
    db.delete('exerciseSessions');
    db.delete('exerciseInstances');
  }

}