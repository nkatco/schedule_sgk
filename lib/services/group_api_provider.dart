import 'dart:convert';

import 'package:schedule_sgk/models/group.dart';
import 'package:http/http.dart' as http;

import '../repositories/favorites_repository.dart';

class GroupProvider {
  final favoritesRepository = FavoritesRepository();

  // https://mfc.samgk.ru/api/groups

  Future<List<Group>> getGroup() async {
    try {
      final response = await http.get(Uri.parse('https://mfc.samgk.ru/api/groups'));

      if (response.statusCode == 200) {
        final List<dynamic> groupJson = json.decode(
            utf8.decode(response.bodyBytes));
        final List<Group> groups = groupJson.map((json) => Group.fromJson(json)).toList();
        for (Group group in groups) {
          if (await favoritesRepository.isKeyRegistered(group.id.toString())) {
            group.favorite = true;
          }
        }
        groups.sort((a, b) => a.name.compareTo(b.name));
        return groups;
      } else {
        throw Exception(
            'Error fetching groups. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error in getGroup: $error");
      throw Exception('Error fetching groups');
    }
  }
  Future<List<Group>> searchGroups(String searchTerm) async {
    List<Group> allGroups = await getGroup();
    List<Group> searchedGroups = allGroups
        .where((group) =>
        group.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    return searchedGroups;
  }
}