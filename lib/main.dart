import 'dart:async';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'mood_button.dart';
import 'moods.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        return db.execute(
          """
          CREATE TABLE moods(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, moodId INTEGER, timestamp TEXT);
          """,
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 3,
    );
  }


  Future<void> insertMood(MoodEntry mood) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'moods',
      mood.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<List<MoodEntry>> getAllMoods() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('moods');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MoodEntry.fromDb(
        id: maps[i]['id'],
        moodId: maps[i]['moodId'],
        timestamp: maps[i]['timestamp'],
      );
    });
  }

  Future<void> updateMood(MoodEntry mood) async {
    // Get a reference to the database.
    final Database db = await database;

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
    final Database db = await database;

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

  // final Database db = await DatabaseUtils.initMoodDatabase();
  // DatabaseUtils dbHelper = DatabaseUtils(db);

  for (var i = 0; i < 100; i++) {
    DatabaseUtils.db.deleteMood(i);
  }

  // var mood = new MoodEntry(moodId: 1);
  // dbHelper.insertMood(mood);

  // print(await dbHelper.moods());
  runApp(MoodLoggerApp());
}

class MoodLoggerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Mood Logger",
      home: new MoodScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        fontFamily: 'Roboto',

        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
          button: TextStyle(fontSize: 24.0)
        )
      ),
    );
  }
}

class MoodScreen extends StatefulWidget {
  @override
  State createState() => new MoodScreenState();
  
}

class MoodScreenState extends State<MoodScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mood Logger"),
        backgroundColor: Theme.of(context).primaryColor,),
        body: FutureBuilder<List<MoodEntry>>(
              future: DatabaseUtils.db.getAllMoods(),
              builder: (BuildContext context, AsyncSnapshot<List<MoodEntry>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      MoodEntry item = snapshot.data[index];
                      return ListTile(
                        title: Text(MoodToName.getMoodName(item.moodId) + " " + MoodToName.getMoodEmoji(item.moodId)),
                        leading: Text(item.id.toString()),
                        trailing: Text(item.timestamp),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator(semanticsLabel: "loading...",));
                }
              },
            ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: IconThemeData(size: 22.0),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          onClose: () => setState(() {}),
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Text(MoodToName.getMoodEmoji(0)),
              label: MoodToName.getMoodName(0),
              onTap: () => DatabaseUtils.db.insertMood(MoodEntry(moodId: 0))
            ),
            SpeedDialChild(
              child: Text(MoodToName.getMoodEmoji(1)),
              label: MoodToName.getMoodName(1),
              onTap: () => DatabaseUtils.db.insertMood(MoodEntry(moodId: 1))
            ),
            SpeedDialChild(
              child: Text(MoodToName.getMoodEmoji(2)),
              label: MoodToName.getMoodName(2),
              onTap: () => DatabaseUtils.db.insertMood(MoodEntry(moodId: 2))
            ),
            SpeedDialChild(
              child: Text(MoodToName.getMoodEmoji(3)),
              label: MoodToName.getMoodName(3),
              onTap: () => DatabaseUtils.db.insertMood(MoodEntry(moodId: 3))
            ),
            SpeedDialChild(
              child: Text(MoodToName.getMoodEmoji(4)),
              label: MoodToName.getMoodName(4),
              onTap: () => DatabaseUtils.db.insertMood(MoodEntry(moodId: 4))
            ),SpeedDialChild(
              child: Text(MoodToName.getMoodEmoji(5)),
              label: MoodToName.getMoodName(5),
              onTap: () => DatabaseUtils.db.insertMood(MoodEntry(moodId: 5))
            ),
          ],
        ),
    );
  }

  Widget _buildMoodInput() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new CustomButton(
            id: 0,
            onPressed: () async {
              await DatabaseUtils.db.insertMood(
                MoodEntry(
                  moodId: 0
                )
              );
            },
          )
        ],
      ),
    );
  }
}

class MoodEntry {
  final int id;
  final int moodId;
  final String timestamp; 

  MoodEntry({this.id, this.moodId}) :
    timestamp = new DateFormat("HH:mm dd-MM-yyyy").format(new DateTime.now());
  
  MoodEntry.fromDb({this.id, this.moodId, this.timestamp}); // default constructor
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'moodId': moodId,
      'timestamp': timestamp
    };
  }

  @override
  String toString() {
    String emoji = MoodToName.getMoodEmoji(moodId);
    return 'MoodEntry: {id: $id, moodId: $moodId, mood: $emoji, timestamp: $timestamp}';
  }
}