import 'package:fuzzy/fuzzy.dart';
import 'package:schedule_sgk/models/group.dart';
import 'package:schedule_sgk/DAO/group_dao.dart';
import 'package:schedule_sgk/services/group_api_provider.dart';

class GroupsRepository {
  final GroupProvider _groupsProvider = GroupProvider();

  final GroupDAO _groupDAO = GroupDAO();

  Future<List<Group>> getAllGroups() async {
    List<Group> cachedGroups = _groupDAO.getCashedGroups();

    if (cachedGroups.isEmpty) {
      cachedGroups = await _groupsProvider.getGroup();
      _groupDAO.setCashedGroup(cachedGroups);
    }

    return cachedGroups;
  }

  Future<List<Group>> searchGroups(String searchTerm) async {
    List<Group> cachedGroups = _groupDAO.getCashedGroups();

    if (cachedGroups.isEmpty) {
      cachedGroups = await _groupsProvider.getGroup();
      _groupDAO.setCashedGroup(cachedGroups);
    }

    if (searchTerm.isEmpty) {
      return cachedGroups;
    }

    List<Group> newGroups = List.empty();

    var fuse = Fuzzy(
      cachedGroups,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            getter: (Group item) => item.name,
            weight: 1.0,
            name: 'name',
          ),
        ],
        findAllMatches: true,
        tokenize: true,
        threshold: 0.3,
      ),
    );
    var results = fuse.search(searchTerm);
    newGroups = results.map((result) => result.item).toList();
    return newGroups;
  }
}
