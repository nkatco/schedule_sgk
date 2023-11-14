abstract class TeacherState {

}
class TeacherEmptyState extends TeacherState {}

class TeacherLoadingState extends TeacherState {}

class TeacherLoadedState extends TeacherState {
  List<dynamic> loadedTeacher;
  TeacherLoadedState({required this.loadedTeacher});
}

class TeacherErrorState extends TeacherState {
  final String errorText;

  TeacherErrorState({required this.errorText});
}