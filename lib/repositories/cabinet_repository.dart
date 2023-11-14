import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/services/cabinet_api_provider.dart';

class CabinetsRepository {
  final CabinetProvider _cabinetsProvider = CabinetProvider();
  Future<List<Cabinet>> getAllCabinets() => _cabinetsProvider.getCabinet();
  Future<List<Cabinet>> searchCabinets(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return getAllCabinets();
    }

    return _cabinetsProvider.searchCabinets(searchTerm);
  }
}