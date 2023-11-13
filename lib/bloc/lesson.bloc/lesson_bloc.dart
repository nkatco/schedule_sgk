import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/item.dart';
import '../../models/lesson.dart';
import '../../repositories/lesson_repository.dart';
import 'lesson_event.dart';
import 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final LessonsRepository lessonRepository;

  LessonBloc({required this.lessonRepository}) : super(LessonEmptyState()) {
    on<LessonLoadEvent>((event, emit) async => await _loadLessons(
      item: event.item,
      date: event.date,
    ));
  }

  Future<void> _loadLessons({required Item item, required String date}) async {
    emit(LessonLoadingState());
    try {
      final List<Lesson> loadedLessonList =
      await lessonRepository.getAllLessons(item, date);
      if(loadedLessonList.length != 0) {
        emit(LessonLoadedState(loadedLesson: loadedLessonList));
      } else {
        emit(LessonEmptyState());
      }
    } catch (error) {
      print("Error in LessonLoadEvent: $error");
      emit(LessonErrorState());
    }
  }
}
