import 'package:intl/intl.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_bloc.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../DAO/group_dao.dart';
import '../bloc/group.bloc/group_event.dart';
import '../models/group.dart';
import '../pages/lessons_page.dart';
import '../repositories/favorites_repository.dart';

class GroupList extends StatelessWidget {
  final FavoritesRepository favoritesRepository = FavoritesRepository();
  final GroupDAO groupDAO = GroupDAO();

  GroupList({Key? key}) : super(key: key);

  void navigateToLesson(BuildContext context, Group group) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LessonsPage(item: group, date: formattedDate),
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
    return BlocBuilder<GroupBloc, GroupState>(
      builder: (context, state) {
        final GroupBloc groupBloc = context.read<GroupBloc>();
        if (state is GroupEmptyState) {
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
        if (state is GroupLoadingState) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: ScreenUtil().setSp(10),
            ),
          );
        }
        if (state is GroupLoadedState) {
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(0), ScreenUtil().setSp(15), ScreenUtil().setSp(0), ScreenUtil().setSp(0)),
            itemCount: state.loadedGroup.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                navigateToLesson(context, state.loadedGroup[index]);
              },
              child: Column(
                children: [
                  InkResponse(
                    onLongPress: () {
                      if (state.loadedGroup[index].favorite == true) {
                        state.loadedGroup[index].favorite = false;
                        favoritesRepository.deleteFavorite(state.loadedGroup[index]!.id.toString());
                      } else {
                        state.loadedGroup[index].favorite = true;
                        favoritesRepository.insertFavorite(state.loadedGroup[index]!.id.toString());
                      }
                      groupDAO.modifyFavoriteGroup(state.loadedGroup[index]);
                      groupBloc.add(GroupLoadEvent());
                    },
                    onTap: () {
                      navigateToLesson(context, state.loadedGroup[index]);
                    },
                    child: Container(
                      height: ScreenUtil().setSp(55),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(ScreenUtil().setSp(15), ScreenUtil().setSp(0), ScreenUtil().setSp(15), ScreenUtil().setSp(0)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${state.loadedGroup[index]?.name ?? "Неизвестно"}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.labelMedium?.color,
                                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                fontSize: ScreenUtil().setSp(13),
                              ),
                            ),
                            if (state.loadedGroup[index]?.favorite == true)
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
                  SizedBox(height: ScreenUtil().setSp(10)),
                ],
              ),
            ),
          );
        }
        if (state is GroupErrorState) {
          // Handle the error state here.
        }
        return CupertinoActivityIndicator(
          radius: ScreenUtil().setSp(15),
        );
      },
    );
  }
}
