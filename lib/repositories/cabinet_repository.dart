import 'package:fuzzy/fuzzy.dart';
import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/services/cabinet_api_provider.dart';

import '../DAO/cabinet_dao.dart';

class CabinetsRepository {
  final CabinetProvider _cabinetsProvider = CabinetProvider();

  final CabinetDAO _cabinetDAO = CabinetDAO();

  Future<List<Cabinet>> getAllCabinets() async {
    List<Cabinet> cachedCabinets = _cabinetDAO.getCashedCabinets();

    if (cachedCabinets.isEmpty) {
      cachedCabinets = await _cabinetsProvider.getCabinet();
      _cabinetDAO.setCashedCabinet(cachedCabinets);
    }

    return cachedCabinets;
  }

  Future<Cabinet?> searchCabinetsByKey(String key) async {
    List<Cabinet> cabinets = await getAllCabinets();
    List<Cabinet> matchingCabinets = List.empty();

    for (Cabinet cabinet in cabinets) {
      if (cabinet.getKey().toLowerCase().contains(key.toLowerCase())) {
        matchingCabinets.add(cabinet);
      }
    }
    if(matchingCabinets.isNotEmpty) {
      return matchingCabinets[0];
    }
    return null;
  }

  Future<List<Cabinet>> searchCabinets(String searchTerm) async {
    List<Cabinet> cachedCabinets = _cabinetDAO.getCashedCabinets();

    if (cachedCabinets.isEmpty) {
      cachedCabinets = await _cabinetsProvider.getCabinet();
      _cabinetDAO.setCashedCabinet(cachedCabinets);
    }

    if (searchTerm.isEmpty) {
      return cachedCabinets;
    }

    List<Cabinet> newTeachers = List.empty();

    var fuse = Fuzzy(
      cachedCabinets,
      options: FuzzyOptions(
        keys: [
          WeightedKey(
            getter: (Cabinet item) => item.name,
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
    newTeachers = results.map((result) => result.item).toList();
    return newTeachers;
  }
}