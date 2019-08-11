import 'package:mood_logger/screens/analytics_widget.dart';
import 'package:flutter/material.dart';
import 'moods.dart';
import 'database.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


void main() async {

  // final Database db = await DatabaseUtils.initMoodDatabase();
  // DatabaseUtils dbHelper = DatabaseUtils(db);

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
  int _navIndex = 0;
  final List<Widget> _children = [
    FutureBuilder<List<MoodEntry>>(
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
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
    AnalyticsWidget(Colors.green),
    AnalyticsWidget(Colors.indigo)
    
  ];

  void onTabTapped(int index) {
    setState(() {
      _navIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mood Logger"),
        backgroundColor: Theme.of(context).primaryColor,),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _navIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.sentiment_satisfied),
              title: new Text('Moods'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.timeline),
              title: new Text('Analytics'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.bubble_chart),
              title: new Text('AI'),
            ),
          ]
        ),
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
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
        floatingActionButton: new Visibility (
          visible: _navIndex == 0, 
          child: SpeedDial(
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
        )
    );
  }
}