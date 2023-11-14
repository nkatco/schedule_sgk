abstract class GroupEvent {
  
}
class GroupLoadEvent extends GroupEvent {

}
class GroupClearEvent extends GroupEvent {

}
class GroupSearchEvent extends GroupEvent {
  final String searchTerm;

  GroupSearchEvent({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}