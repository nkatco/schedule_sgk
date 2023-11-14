abstract class CabinetState {

}
class CabinetEmptyState extends CabinetState {}

class CabinetLoadingState extends CabinetState {}

class CabinetLoadedState extends CabinetState {
  List<dynamic> loadedCabinet;
  CabinetLoadedState({required this.loadedCabinet});
}

class CabinetErrorState extends CabinetState {
  final String errorText;

  CabinetErrorState({required this.errorText});
}