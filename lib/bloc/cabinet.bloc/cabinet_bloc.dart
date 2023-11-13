import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_event.dart';
import 'package:schedule_sgk/repositories/cabinet_repository.dart';
import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CabinetBloc extends Bloc<CabinetEvent, CabinetState> {

  CabinetsRepository cabinetRepository;

  CabinetBloc({required this.cabinetRepository})
      : super(CabinetEmptyState()) {
    _loadCabinets();
  }

  Future<void> _loadCabinets() async {
    emit(CabinetLoadingState());
    try {
      final List<Cabinet> loadedCabinetList = await cabinetRepository.getAllCabinets();
      emit(CabinetLoadedState(loadedCabinet: loadedCabinetList));
    } catch (error) {
      print("Error in CabinetLoadEvent: $error");
      emit(CabinetErrorState());
    }
  }
}
