import 'package:intl/intl.dart';

class MoodToName {
  static final Map<int,Map<String,String>> map = {
    0: {"sad": "😢"},
    1: {"angry": "😠"},
    2: {"slightly upset": "🙁"},
    3: {"ok": "😐"},
    4: {"happy": "😊"},
    5: {"super happy": "😁"},
  };
  static String getMoodName(int moodId) {
    return MoodToName.map[moodId].keys.first;
  }
  static String getMoodEmoji(int moodId) {
    return MoodToName.map[moodId].values.first;
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