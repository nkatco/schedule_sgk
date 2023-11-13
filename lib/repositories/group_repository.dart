import 'package:schedule_sgk/models/group.dart';
import 'package:schedule_sgk/services/group_api_provider.dart';

class GroupsRepository {
  final GroupProvider _groupsProvider = GroupProvider();
  Future<List<Group>> getAllGroups() => _groupsProvider.getGroup();
}