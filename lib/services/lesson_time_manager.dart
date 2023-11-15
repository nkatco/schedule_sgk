class LessonTimeManager {
  static Map<int, String> lessonTimes = {
    1: '08:25 - 10:00',
    2: '10:10 - 11:45',
    3: '12:15 - 13:50',
    4: '14:00 - 15:35',
    5: '15:45 - 17:20',
    6: '17:30 - 19:05',
    7: '19:15 - 20:50'
  };

  static Map<int, String> lessonTimesMonday = {
    0: '08:25 - 09:10',
    1: '09:15 - 10:55',
    2: '11:00 - 13:00',
    3: '13:05 - 14:45',
    4: '14:50 - 16:30',
    5: '16:35 - 18:15',
    6: '18:20 - 20:00',
  };

  static String getLessonTime(int id, DateTime dateTime) {
    DateTime now = dateTime;
    bool isMonday = now.weekday == DateTime.monday;

    String time = lessonTimes[id] ?? '-';
    if (isMonday) {
      time = adjustTimeForMonday(id);
    }

    return time;
  }

  static String adjustTimeForMonday(int id) {
    String time = lessonTimesMonday[id] ?? '-';
    return time;
  }
}
