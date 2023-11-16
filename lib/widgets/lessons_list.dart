import 'package:schedule_sgk/bloc/lesson.bloc/lesson_bloc.dart';
import 'package:schedule_sgk/bloc/lesson.bloc/lesson_event.dart';
import 'package:schedule_sgk/bloc/lesson.bloc/lesson_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/models/teacher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../DAO/cabinet_dao.dart';
import '../DAO/group_dao.dart';
import '../DAO/teacher_dao.dart';
import '../models/group.dart';
import '../models/item.dart';
import '../repositories/favorites_repository.dart';
import '../services/lesson_time_manager.dart';

class LessonList extends StatelessWidget {
  final Item item;
  final DateTime dateTime;
  final FavoritesRepository favoritesRepository = FavoritesRepository();

  LessonList({Key? key, required this.item, required this.dateTime});

  _loadItem() {
    if (item is Group) {
      Group? group = item as Group?;
      if (group?.favorite == true) {
        group?.favorite = false;
        favoritesRepository.deleteFavorite(item.getKey());
      } else {
        group?.favorite = true;
        favoritesRepository.insertFavorite(item.getKey());
      }
      GroupDAO groupDAO = GroupDAO();
      groupDAO.modifyFavoriteGroup(group!);
    } else if (item is Teacher) {
      Teacher? teacher = item as Teacher?;
      if (teacher?.favorite == true) {
        teacher?.favorite = false;
        favoritesRepository.deleteFavorite(item.getKey());
      } else {
        teacher?.favorite = true;
        favoritesRepository.insertFavorite(item.getKey());
      }
      TeacherDAO teacherDAO = TeacherDAO();
      teacherDAO.modifyFavoriteTeacher(teacher!);
    } else if (item is Cabinet) {
      Cabinet? cabinet = item as Cabinet?;
      if (cabinet?.favorite == true) {
        cabinet?.favorite = false;
        favoritesRepository.deleteFavorite(item.getKey());
      } else {
        cabinet?.favorite = true;
        favoritesRepository.insertFavorite(item.getKey());
      }
      CabinetDAO cabinetDAO = CabinetDAO();
      cabinetDAO.modifyFavoriteCabinet(cabinet!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        if (state is LessonEmptyState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0.h),
                child: Center(
                  child: Text(
                    'Расписания нет!',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                      fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (state is LessonLoadingState) {
          return Center(
            child: CupertinoActivityIndicator(
              color: Color(0xFFFFFFFF),
              radius: 10.r,
            ),
          );
        }
        if (state is LessonLoadedState) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(10.w, 15.h, 0.w, 0.h),
                    child: Text(
                      '${item.getAuthor()}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.fromLTRB(0.w, 13.h, 10.w, 0.h),
                    onPressed: () {
                      _loadItem();
                      context.read<LessonBloc>().add(LessonUpdateEvent());
                    },
                    icon: Image.asset(
                      'assets/${item.getFavorite() ? 'favorite' : 'unfavorite'}.png',
                      width: 35.w,
                      height: 35.h,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 0.h),
                  itemCount: state.loadedLesson.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Container(
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(20.w, 0.h, 0.w, 0.h),
                                child: Text(
                                  '${state.loadedLesson[index]?.num ?? "Неизвестно"}',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.labelMedium?.color,
                                    fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      width: 200.w,
                                      child: Text(
                                        '${state.loadedLesson[index]?.title ?? "Неизвестно"}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.labelMedium?.color,
                                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                          fontSize: 10.5.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      width: 200.w,
                                      margin: EdgeInsets.fromLTRB(0.w, 4.h, 0.w, 0.h),
                                      child: Text(
                                        '${state.loadedLesson[index]?.teacherName ?? "Неизвестно"}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.labelMedium?.color,
                                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0.w, 0.h, 20.w, 0.h),
                                    child: Text(
                                      '${state.loadedLesson[index]?.cab ?? "Неизвестно"}',
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.labelMedium?.color,
                                        fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                        fontSize: 10.5.sp,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0.w, 3.h, 20.w, 0.h),
                                    child: Text(
                                      LessonTimeManager.getLessonTime(state.loadedLesson[index]?.num ?? '-', dateTime),
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.labelMedium?.color,
                                        fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        if (state is LessonErrorState) {
          return Center(
            child: Text(
              'Error',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: 14.sp,
              ),
            ),
          );
        }
        return CupertinoActivityIndicator(
          color: Color(0xFFFFFFFF),
          radius: 10.r,
        );
      },
    );
  }
}
