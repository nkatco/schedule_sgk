import '../models/group.dart';

class GroupDAO {
  static final GroupDAO _singleton = GroupDAO._internal();

  GroupDAO._internal();

  factory GroupDAO() {
    return _singleton;
  }

  List<Group> _groups = List.empty();

  void setCashedGroup(List<Group> groups) {
    _groups = groups;
  }

  void modifyFavoriteGroup(Group targetGroup) {
    try {
      _groups.firstWhere((cabinet) => cabinet == targetGroup).favorite = targetGroup.favorite;
    } catch(_) {

    }
  }

  List<Group> getCashedGroups() => _groups;
}
