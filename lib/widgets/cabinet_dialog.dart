import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/widgets/search/cabinet_search_list.dart';

import '../bloc/cabinet.bloc/cabinet_bloc.dart';
import '../bloc/cabinet.bloc/cabinet_event.dart';


class CabinetDialog extends StatelessWidget {
  final CabinetBloc cabinetBloc;

  const CabinetDialog({Key? key, required this.cabinetBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cabinetBloc,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          cabinetBloc.add(CabinetLoadEvent());
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/glass.png',
                                    width: 15,
                                    height: 15,
                                  ),
                                  padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: TextField(
                                      onChanged: (searchTerm) {
                                        cabinetBloc.add(CabinetSearchEvent(searchTerm: searchTerm));
                                      },
                                      style: TextStyle(
                                        fontFamily: Theme.of(context).textTheme.bodyText1?.fontFamily,
                                        color: Theme.of(context).textTheme.labelMedium?.color,
                                        fontSize: 16,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Поиск',
                                        hintStyle: TextStyle(
                                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 250,
                        height: 250,
                        child: CabinetSearchList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
