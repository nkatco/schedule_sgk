import '../models/item.dart';
import '../models/lesson.dart';
import '../services/lesson_api_provider.dart';

class LessonsRepository {
  final LessonProvider _lessonsProvider = LessonProvider();
  Future<List<Lesson>> getAllLessons(Item item, String date) => _lessonsProvider.getLesson(item, date);
}