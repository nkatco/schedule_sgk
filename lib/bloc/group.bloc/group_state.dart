abstract class GroupState {

}
class GroupEmptyState extends GroupState {}

class GroupLoadingState extends GroupState {}

class GroupLoadedState extends GroupState {
  List<dynamic> loadedGroup;
  GroupLoadedState({required this.loadedGroup});
}

class GroupErrorState extends GroupState {
  final String errorText;

  GroupErrorState({required this.errorText});
}
