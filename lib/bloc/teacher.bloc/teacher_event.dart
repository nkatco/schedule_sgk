abstract class TeacherEvent {
  
}
class TeacherLoadEvent extends TeacherEvent {

}
class TeacherClearEvent extends TeacherEvent {

}
class TeacherSearchEvent extends TeacherEvent {
  final String searchTerm;

  TeacherSearchEvent({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}