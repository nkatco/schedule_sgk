import 'dart:convert';

import 'package:schedule_sgk/models/teacher.dart';
import 'package:http/http.dart' as http;

import '../repositories/favorites_repository.dart';

class TeacherProvider {
  final favoritesRepository = FavoritesRepository();

  // https://asu.samgk.ru/api/teachers

  Future<List<Teacher>> getTeacher() async {
    final favoritesRepository = FavoritesRepository();

    try {
      final response = await http.get(Uri.parse('https://asu.samgk.ru/api/teachers'));

      if (response.statusCode == 200) {
        final List<dynamic> teacherJson = json.decode(utf8.decode(response.bodyBytes));
        final List<Teacher> teachers = teacherJson.map((json) => Teacher.fromJson(json)).toList();
        for (Teacher teacher in teachers) {
          if (await favoritesRepository.isKeyRegistered(teacher.id.toString())) {
            teacher.favorite = true;
          }
        }
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
  Future<List<Teacher>> searchTeachers(String searchTerm) async {
    List<Teacher> allGroups = await getTeacher();
    List<Teacher> searchedGroups = allGroups
        .where((group) =>
        group.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    return searchedGroups;
  }
}