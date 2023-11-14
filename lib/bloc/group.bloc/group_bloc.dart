import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_event.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_state.dart';
import 'package:schedule_sgk/repositories/group_repository.dart';
import 'package:schedule_sgk/models/group.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  GroupsRepository groupRepository;

  GroupBloc({required this.groupRepository}) : super(GroupEmptyState()) {
    on<GroupLoadEvent>((event, emit) async => _loadGroups());
    on<GroupSearchEvent>((event, emit) async => _searchGroup(event.searchTerm));
  }

  Future<void> _loadGroups() async {
    emit(GroupLoadingState());
    try {
      final List<Group> loadedGroupList = await groupRepository.getAllGroups();
      emit(GroupLoadedState(loadedGroup: loadedGroupList));
    } catch (error) {
      print("Error in GroupLoadEvent: $error");
      emit(GroupErrorState(errorText: error.toString()));
    }
  }

  Future<void> _searchGroup(String searchTerm) async {
    try {
      final List<Group> searchedGroups =
      await groupRepository.searchGroups(searchTerm);
      emit(GroupLoadedState(loadedGroup: searchedGroups));
    } catch (error) {
      print("Error in GroupSearchEvent: $error");
      emit(GroupErrorState(errorText: error.toString()));
    }
  }
}
