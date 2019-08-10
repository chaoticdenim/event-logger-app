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