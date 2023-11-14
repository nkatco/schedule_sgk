import 'package:schedule_sgk/models/teacher.dart';
import 'package:schedule_sgk/services/teacher_api_provider.dart';

class TeachersRepository {
  final TeacherProvider _teachersProvider = TeacherProvider();
  Future<List<Teacher>> getAllTeachers() => _teachersProvider.getTeacher();
  Future<List<Teacher>> getLoadedTeachers() => _teachersProvider.getTeacher();
  Future<List<Teacher>> searchTeachers(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return getAllTeachers();
    }

    return _teachersProvider.searchTeachers(searchTerm);
  }
}