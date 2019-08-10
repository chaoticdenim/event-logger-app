import 'dart:async';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class TypeToName {
  static final Map map = {
    0: "sad",
    1: "angry",
    2: "slightly upset",
    3: "ok",
    4: "happy",
    5: "super happy",
  };
  static String getMoodName(int mood_type) {
    return TypeToName.map[mood_type];
  }
}

class DatabaseUtils {

  final Database database;

  DatabaseUtils(this.database);

  static Future<Database> initMoodDatabase() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'moods_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          """
          CREATE TABLE moods(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, mood_type INTEGER, timestamp TEXT);
          CREATE TABLE mood_types_table(id INTEGER PRIMARY KEY, name TEXT);

          INSERT INTO mood_types_table (id, name)
          VALUES 
          (0, 'sad'),
          (1, 'angry'),
          (2, 'slightly upset'),
          (3, 'ok'),
          (4, 'happy'),
          (5, 'super happy');
          """,
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 2,
    );
  }


  Future<void> insertMood(MoodEntry mood) async {
    // Get a reference to the database.
    final Database db = database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'moods',
      mood.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<MoodEntry> fetchMood(int id) async {
    final Future<List<Map<String, dynamic>>> futureMaps = database.query('moods', where: 'id = ?', whereArgs: [id]);
    var maps = await futureMaps;

    if (maps.length != 0) {
      return MoodEntry.fromDb(maps.first);
    }

    return null;
  }

  Future<List<MoodEntry>> moods() async {
    // Get a reference to the database.
    final Database db = database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('moods');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MoodEntry(
        id: maps[i]['id'],
        mood_type: maps[i]['mood_type'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  Future<void> updateMood(MoodEntry mood) async {
    // Get a reference to the database.
    final db = database;

    // Update the given Dog.
    await db.update(
      'moods',
      mood.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [mood.id],
    );
  }

  Future<void> deleteMood(int id) async {
    // Get a reference to the database.
    final db = database;

    // Remove the Dog from the database.
    await db.delete(
      'moods',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}

void main() async {

  final Database db = await DatabaseUtils.initMoodDatabase();
  DatabaseUtils db_helper = DatabaseUtils(db);
  // final int id = await db_helper.getLastId();
  var arbitraryId = 0;
  var user_input = 2;

  for (var i = 0; i < 12; i++) {
    db_helper.deleteMood(i);
  }
    print(await db_helper.moods());
    runApp(
    new MaterialApp(
      title: "Mood Logger",
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("Mood Logger"),
        ),
      ),
    ),
  );
}

class MoodLoggerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "r",
      home: new MoodScreen(),
    );
  }
}

class MoodScreen extends StatefulWidget {
  @override
  State createState() => new MoodScreenState();
  Widget _buildMoodInput() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new IconButton(
            icon: new Icon(Icons.send),
            onPressed: () => print("lolilol"),
          )
        ],
      ),
    );
  }
}

class MoodScreenState extends State<MoodScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("ta mere la chienne"),),
    );
  }
}

class MoodEntry {
  final int id;
  final int mood_type;
  final String timestamp; 

  MoodEntry.initialize({this.id, this.mood_type}) :
    timestamp = new DateFormat("HH:mm dd-MM-yyyy").format(new DateTime.now());

  MoodEntry.fromDb(Map<String, dynamic> map)
  : id = map["id"],
  mood_type = map["mood_type"],
  timestamp = map["timestamp"];
  
  MoodEntry({this.id, this.mood_type, this.timestamp}); // default constructor
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood_type': mood_type,
      'timestamp': timestamp
    };
  }

  @override
  String toString() {
    String name = TypeToName.getMoodName(mood_type);
    return 'MoodEntry: {id: $id, mood_type: $mood_type, mood name: $name, timestamp: $timestamp}';
  }
}