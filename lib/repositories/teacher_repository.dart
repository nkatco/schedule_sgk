import 'package:schedule_sgk/DAO/teacher_dao.dart';
import 'package:schedule_sgk/models/teacher.dart';
import 'package:schedule_sgk/services/teacher_api_provider.dart';

class TeachersRepository {
  final TeacherProvider _teachersProvider = TeacherProvider();

  final TeacherDAO _teacherDAO = TeacherDAO();

  Future<List<Teacher>> getAllTeachers() async {
    List<Teacher> cachedTeachers = _teacherDAO.getCashedTeachers();

    if (cachedTeachers.isEmpty) {
      cachedTeachers = await _teachersProvider.getTeacher();
      _teacherDAO.setCashedTeacher(cachedTeachers);
    }

    return cachedTeachers;
  }

  Future<List<Teacher>> searchTeachers(String searchTerm) async {
    List<Teacher> cachedTeachers = _teacherDAO.getCashedTeachers();

    if (cachedTeachers.isEmpty) {
      cachedTeachers = await _teachersProvider.getTeacher();
      _teacherDAO.setCashedTeacher(cachedTeachers);
    }

    if (searchTerm.isEmpty) {
      return cachedTeachers;
    }

    return cachedTeachers
        .where((teacher) => teacher.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();
  }
}