import '../models/teacher.dart';

class TeacherDAO {
  static final TeacherDAO _singleton = TeacherDAO._internal();

  TeacherDAO._internal();

  factory TeacherDAO() {
    return _singleton;
  }

  List<Teacher> _teachers = List.empty();

  void setCashedTeacher(List<Teacher> teachers) {
    _teachers = teachers;
  }

  void modifyFavoriteTeacher(Teacher targetTeacher) {
    try {
      _teachers.firstWhere((teacher) => teacher == targetTeacher).favorite = targetTeacher.favorite;
    } catch(_) {

    }
  }

  List<Teacher> getCashedTeachers() => _teachers;
}
