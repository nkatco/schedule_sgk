abstract class CabinetEvent {
  
}
class CabinetLoadEvent extends CabinetEvent {

}
class CabinetClearEvent extends CabinetEvent {

}
class CabinetSearchEvent extends CabinetEvent {
  final String searchTerm;

  CabinetSearchEvent({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}