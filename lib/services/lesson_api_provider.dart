  import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/models/group.dart';
import 'package:schedule_sgk/models/item.dart';
import 'package:schedule_sgk/models/teacher.dart';

import '../models/lesson.dart';

class LessonProvider {
  // Group: https://asu.samgk.ru//api/schedule/group_id/${date:2023-11-14}
  // Teacher: https://asu.samgk.ru//api/schedule/teacher/${date:2023-11-14}/teacher_id
  // Cabinet: https://asu.samgk.ru//api/schedule/cabs/${date:2023-11-14}/cabNum/cabinet_id

  Future<List<Lesson>> getLesson(Item item, String date) async {
    try {
      late http.Response response;
      if (item is Group) {
        response = await http.get(Uri.parse('https://asu.samgk.ru//api/schedule/${item.id}/$date'));
      } else if (item is Teacher) {
        response = await http.get(Uri.parse('https://asu.samgk.ru//api/schedule/teacher/$date/${item.id}'));
      } else if (item is Cabinet) {
        response = await http.get(Uri.parse('https://asu.samgk.ru//api/schedule/cabs/$date/cabNum/${item.id}'));
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> lessonJsonList = responseData['lessons'];
        List<Lesson> lessons = lessonJsonList.map((lessonJson) => Lesson.fromJson(lessonJson)).toList();
        if(DateTime.parse(date).weekday == DateTime.monday && lessons[0].num == 1) {
          lessons = await _addLessonAtBeginning(lessons, DateTime.parse(date));
        }
        return lessons;
      } else {
        throw Exception('Error fetching lessons. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error in getLesson: $error");
      throw Exception('Error fetching lessons');
    }
  }
   Future<List<Lesson>> _addLessonAtBeginning(List<Lesson> lessons, DateTime dateTime) async {
    bool isMonday = dateTime.weekday == DateTime.monday;
    print('${dateTime.toString()} | ${dateTime.weekday}');

    if (isMonday && lessons.isNotEmpty && lessons.first.num == 1) {
      List<Lesson> newLessons = lessons;
      Lesson newLesson = Lesson(
          num: 0,
          title: 'Разговоры о важном',
          cab: lessons[0].cab,
          teacherName: lessons[0].teacherName
      );
      newLessons.insert(0, newLesson);
      return newLessons;
    }
    return lessons;
  }
}