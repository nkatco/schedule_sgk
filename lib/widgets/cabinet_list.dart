import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_bloc.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_state.dart';

class CabinetList extends StatelessWidget {

  const CabinetList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CabinetBloc, CabinetState>(
      builder: (context, state) {
        if (state is CabinetEmptyState) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: 14,
              ),
            ),
          );
        }
        if (state is CabinetLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CabinetLoadedState) {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            itemCount: state.loadedCabinet.length,
            itemBuilder: (context, index) => Column(
              children: [
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Center(
                    child: Text(
                      '${state.loadedCabinet[index]?.name ?? "Неизвестно"}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }
        if (state is CabinetErrorState) {
          return Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: 14,
              ),
            ),
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}