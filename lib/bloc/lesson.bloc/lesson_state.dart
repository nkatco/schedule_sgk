abstract class LessonState {

}
class LessonEmptyState extends LessonState {}

class LessonLoadingState extends LessonState {}

class LessonLoadedState extends LessonState {
  List<dynamic> loadedLesson;
  LessonLoadedState({required this.loadedLesson});
}

class LessonErrorState extends LessonState {}