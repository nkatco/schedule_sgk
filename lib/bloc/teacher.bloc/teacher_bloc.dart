import 'package:schedule_sgk/bloc/teacher.bloc/teacher_event.dart';
import 'package:schedule_sgk/repositories/teacher_repository.dart';
import 'package:schedule_sgk/models/teacher.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {

  TeachersRepository teacherRepository;

  TeacherBloc({required this.teacherRepository})
      : super(TeacherEmptyState()) {
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    emit(TeacherLoadingState());
    try {
      final List<Teacher> loadedTeacherList = await teacherRepository.getAllTeachers();
      emit(TeacherLoadedState(loadedTeacher: loadedTeacherList));
    } catch (error) {
      print("Error in TeacherLoadEvent: $error");
      emit(TeacherErrorState());
    }
  }
}
