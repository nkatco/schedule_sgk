import '../models/cabinet.dart';

class CabinetDAO {
  static final CabinetDAO _singleton = CabinetDAO._internal();

  CabinetDAO._internal();

  factory CabinetDAO() {
    return _singleton;
  }

  List<Cabinet> _cabinets = List.empty();

  void setCashedCabinet(List<Cabinet> cabinets) {
    _cabinets = cabinets;
  }

  void modifyFavoriteCabinet(Cabinet targetCabinet) {
    try {
      _cabinets.firstWhere((cabinet) => cabinet == targetCabinet).favorite = targetCabinet.favorite;
    } catch(_) {

    }
  }

  List<Cabinet> getCashedCabinets() => _cabinets;
}
