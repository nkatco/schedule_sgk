import 'dart:convert';

import 'package:schedule_sgk/models/teacher.dart';
import 'package:http/http.dart' as http;

class TeacherProvider {
  // https://asu.samgk.ru/api/teachers

  Future<List<Teacher>> getTeacher() async {
    try {
      final response = await http.get(Uri.parse('https://asu.samgk.ru/api/teachers'));

      if (response.statusCode == 200) {
        final List<dynamic> teacherJson = json.decode(utf8.decode(response.bodyBytes));
        final List<Teacher> teachers = teacherJson.map((json) => Teacher.fromJson(json)).toList();
        teachers.sort((a, b) => a.name.compareTo(b.name));
        return teachers;
      } else {
        throw Exception('Error fetching teachers. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error in getTeacher: $error");
      throw Exception('Error fetching teachers');
    }
  }

}