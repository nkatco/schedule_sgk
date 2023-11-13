import 'dart:convert';

import 'package:schedule_sgk/models/group.dart';
import 'package:http/http.dart' as http;

class GroupProvider {
  // https://mfc.samgk.ru/api/groups

  Future<List<Group>> getGroup() async {
    try {
      final response = await http.get(Uri.parse('https://mfc.samgk.ru/api/groups'));

      if (response.statusCode == 200) {
        final List<dynamic> groupJson = json.decode(
            utf8.decode(response.bodyBytes));
        final List<Group> groups = groupJson.map((json) => Group.fromJson(json)).toList();
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
}