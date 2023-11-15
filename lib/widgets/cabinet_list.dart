import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_bloc.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_event.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_state.dart';
import 'package:schedule_sgk/repositories/favorites_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../DAO/cabinet_dao.dart';
import '../models/cabinet.dart';
import '../pages/lessons_page.dart';

class CabinetList extends StatelessWidget {
  final FavoritesRepository favoritesRepository = FavoritesRepository();
  final CabinetDAO cabinetDAO = CabinetDAO();

  CabinetList({Key? key}) : super(key: key);

  void navigateToLesson(BuildContext context, Cabinet cabinet) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LessonsPage(item: cabinet, date: formattedDate),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var fadeAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return BlocBuilder<CabinetBloc, CabinetState>(
      builder: (context, state) {
        final CabinetBloc cabinetBloc = context.read<CabinetBloc>();
        if (state is CabinetEmptyState) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: ScreenUtil().setSp(14),
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
              padding: EdgeInsets.fromLTRB(0, ScreenUtil().setHeight(15), 0, 0),
              itemCount: state.loadedCabinet.length,
              itemBuilder: (context, index) => GestureDetector(
                child: Column(
                  children: [
                    InkResponse(
                      onLongPress: () {
                        if (state.loadedCabinet[index].favorite == true) {
                          state.loadedCabinet[index].favorite = false;
                          favoritesRepository.deleteFavorite(state.loadedCabinet[index]?.id);
                        } else {
                          state.loadedCabinet[index].favorite = true;
                          favoritesRepository.insertFavorite(state.loadedCabinet[index]?.id);
                        }
                        cabinetDAO.modifyFavoriteCabinet(state.loadedCabinet[index]);
                        cabinetBloc.add(CabinetLoadEvent());
                      },
                      onTap: () {
                        navigateToLesson(context, state.loadedCabinet[index]);
                      },
                      child: Container(
                        height: ScreenUtil().setHeight(55),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.fromLTRB(
                          ScreenUtil().setWidth(15),
                          0,
                          ScreenUtil().setWidth(15),
                          0,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${state.loadedCabinet[index]?.name ?? "Неизвестно"}',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.labelMedium?.color,
                                  fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                  fontSize: ScreenUtil().setSp(13),
                                ),
                              ),
                              if (state.loadedCabinet[index]?.favorite == true)
                                Container(
                                  padding: EdgeInsets.fromLTRB(5.w, 0.h, 0.w, 0.h),
                                  child: Image.asset(
                                    'assets/favorite.png',
                                    width: ScreenUtil().setSp(15),
                                    height: ScreenUtil().setSp(15),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(10)),
                  ],
                ),
              ));
        }
        if (state is CabinetErrorState) {
          return Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: ScreenUtil().setSp(14),
              ),
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
