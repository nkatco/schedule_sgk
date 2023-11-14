import 'dart:convert';

import 'package:schedule_sgk/models/cabinet.dart';
import 'package:http/http.dart' as http;
import 'package:schedule_sgk/repositories/favorites_repository.dart';

class CabinetProvider {
  final favoritesRepository = FavoritesRepository();

  // https://mfc.samgk.ru/api/cabs

  Future<List<Cabinet>> getCabinet() async {
    try {
      final response = await http.get(Uri.parse('https://asu.samgk.ru/api/cabs'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> cabinetJson = json.decode(utf8.decode(response.bodyBytes));

        final List<Cabinet> cabinets = await Future.wait(cabinetJson.entries
            .map((entry) async => Cabinet(
          id: entry.key,
          name: entry.value,
          favorite: await favoritesRepository.isKeyRegistered(entry.key),
        )).toList());
        cabinets.sort((a, b) => a.name.compareTo(b.name));
        return cabinets;
      } else {
        throw Exception('Error fetching cabinets. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error in getCabinet: $error");
      throw Exception('Error fetching cabinets');
    }
  }
  Future<List<Cabinet>> searchCabinets(String searchTerm) async {
    List<Cabinet> allGroups = await getCabinet();
    List<Cabinet> searchedGroups = allGroups
        .where((group) =>
        group.name.toLowerCase().contains(searchTerm.toLowerCase()))
        .toList();

    return searchedGroups;
  }
}