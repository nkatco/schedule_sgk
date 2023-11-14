import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_event.dart';
import 'package:schedule_sgk/repositories/cabinet_repository.dart';
import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CabinetBloc extends Bloc<CabinetEvent, CabinetState> {

  CabinetsRepository cabinetRepository;

  CabinetBloc({required this.cabinetRepository}) : super(CabinetEmptyState()) {
    on<CabinetLoadEvent>((event, emit) async => _loadCabinets());
    on<CabinetSearchEvent>((event, emit) async => _searchCabinet(event.searchTerm));
  }

  Future<void> _loadCabinets() async {
    emit(CabinetLoadingState());
    try {
      final List<Cabinet> loadedCabinetList = await cabinetRepository.getAllCabinets();
      loadedCabinetList.sort((a, b) {
        if (a.favorite == true && b.favorite == false) {
          return -1;
        } else if (a.favorite == false && b.favorite == true) {
          return 1;
        } else {
          return a.name.compareTo(b.name);
        }
      });
      emit(CabinetLoadedState(loadedCabinet: loadedCabinetList));
    } catch (error) {
      print("Error in CabinetLoadEvent: $error");
      emit(CabinetErrorState(errorText: error.toString()));
    }
  }

  Future<void> _searchCabinet(String searchTerm) async {
    try {
      final List<Cabinet> searchedGroups =
      await cabinetRepository.searchCabinets(searchTerm);
      emit(CabinetLoadedState(loadedCabinet: searchedGroups));
    } catch (error) {
      print("Error in GroupSearchEvent: $error");
      emit(CabinetErrorState(errorText: error.toString()));
    }
  }
}
