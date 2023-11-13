import 'dart:convert';

import 'package:schedule_sgk/models/cabinet.dart';
import 'package:http/http.dart' as http;

class CabinetProvider {
  // https://mfc.samgk.ru/api/cabs

  Future<List<Cabinet>> getCabinet() async {
    try {
      final response = await http.get(Uri.parse('https://asu.samgk.ru/api/cabs'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> cabinetJson = json.decode(utf8.decode(response.bodyBytes));

        final List<Cabinet> cabinets = cabinetJson.entries
            .map((entry) => Cabinet(id: entry.key, name: entry.value))
            .toList();
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
}