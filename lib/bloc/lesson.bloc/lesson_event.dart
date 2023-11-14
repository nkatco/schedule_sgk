import 'package:equatable/equatable.dart';

import '../../models/item.dart';

abstract class LessonEvent extends Equatable {
  const LessonEvent();

  @override
  List<Object> get props => [];
}

class LessonLoadEvent extends LessonEvent {
  final Item item;
  final String date;

  const LessonLoadEvent({required this.item, required this.date});

  @override
  List<Object> get props => [item, date];
}

class LessonClearEvent extends LessonEvent {

}
class LessonUpdateEvent extends LessonEvent {

}