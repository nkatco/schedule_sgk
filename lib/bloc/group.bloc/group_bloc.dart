import 'package:schedule_sgk/bloc/group.bloc/group_event.dart';
import 'package:schedule_sgk/repositories/group_repository.dart';
import 'package:schedule_sgk/models/group.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {

  GroupsRepository groupRepository;

  GroupBloc({required this.groupRepository})
      : super(GroupEmptyState()) {
    _loadGroups();
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
}
