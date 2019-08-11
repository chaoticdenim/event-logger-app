import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'moods.dart';

class DatabaseUtils {
  DatabaseUtils._();
  static final DatabaseUtils db = DatabaseUtils._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
    return _database;

    _database = await initMoodDatabase();
    return _database;
  }

  initMoodDatabase() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'moods_database.db'),
      onCreate: (db, version) {
        return db.execute(
          """
          CREATE TABLE moods(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, moodId INTEGER, timestamp TEXT);
          """,
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
  }


  Future<void> insertMood(MoodEntry mood) async {
    final Database db = await database;
    await db.insert(
      'moods',
      mood.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<MoodEntry>> getAllMoods() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('moods');
    return List.generate(maps.length, (i) {
      return MoodEntry.fromDb(
        id: maps[i]['id'],
        moodId: maps[i]['moodId'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  Future<void> updateMood(MoodEntry mood) async {
    final Database db = await database;

    await db.update(
      'moods',
      mood.toMap(),
      where: "id = ?",
      whereArgs: [mood.id],
    );
  }

  Future<void> deleteMood(int id) async {
    final Database db = await database;

    await db.delete(
      'moods',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}