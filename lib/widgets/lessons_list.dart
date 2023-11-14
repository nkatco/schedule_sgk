import 'package:schedule_sgk/bloc/lesson.bloc/lesson_bloc.dart';
import 'package:schedule_sgk/bloc/lesson.bloc/lesson_event.dart';
import 'package:schedule_sgk/bloc/lesson.bloc/lesson_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/models/cabinet.dart';
import 'package:schedule_sgk/models/teacher.dart';

import '../DAO/cabinet_dao.dart';
import '../DAO/group_dao.dart';
import '../DAO/teacher_dao.dart';
import '../models/group.dart';
import '../models/item.dart';
import '../repositories/favorites_repository.dart';

class LessonList extends StatelessWidget {

  final Item item;
  final FavoritesRepository favoritesRepository = FavoritesRepository();

  LessonList({super.key, required this.item});

  _loadItem() {
    if(item is Group) {
      Group? group = item as Group?;
      if (group?.favorite == true) {
        group?.favorite = false;
      } else {
        group?.favorite = true;
      }
      GroupDAO groupDAO = GroupDAO();
      groupDAO.modifyFavoriteGroup(group!);
    } else if(item is Teacher) {
      Teacher? teacher = item as Teacher?;
      if (teacher?.favorite == true) {
        teacher?.favorite = false;
      } else {
        teacher?.favorite = true;
      }
      TeacherDAO teacherDAO = TeacherDAO();
      teacherDAO.modifyFavoriteTeacher(teacher!);
    } else if(item is Teacher) {
      Teacher? teacher = item as Teacher?;
      if (teacher?.favorite == true) {
        teacher?.favorite = false;
      } else {
        teacher?.favorite = true;
      }
      TeacherDAO teacherDAO = TeacherDAO();
      teacherDAO.modifyFavoriteTeacher(teacher!);
    } else if(item is Cabinet) {
      Cabinet? cabinet = item as Cabinet?;
      if (cabinet?.favorite == true) {
        cabinet?.favorite = false;
      } else {
        cabinet?.favorite = true;
      }
      CabinetDAO cabinetDAO = CabinetDAO();
      cabinetDAO.modifyFavoriteCabinet(cabinet!);
    }

    favoritesRepository.insertFavorite(item.getKey());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if(state is LessonEmptyState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                    child: Center(
                      child: Text(
                        'Расписания нет!',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelMedium?.color,
                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                          fontSize: 14,
                        ),
                      ),
                    )
                ),
              ],
            );
          }
          if(state is LessonLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: Color(0xFFFFFFFF),
                radius: 10,
              ),
            );
          }
          if(state is LessonLoadedState) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Text(
                        '${item.getAuthor()}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelMedium?.color,
                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      onPressed: () {
                        _loadItem();
                        context.read<LessonBloc>().add(LessonUpdateEvent());
                      },
                      icon: Image.asset(
                        'assets/${item.getFavorite() ? 'favorite' : 'unfavorite'}.png',
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      itemCount: state.loadedLesson.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(
                                        '${state.loadedLesson[index]?.num ?? "Неизвестно"}',
                                        style: TextStyle(
                                          color: Theme.of(context).textTheme.labelMedium?.color,
                                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                          fontSize: 11,
                                        ),
                                      ),
                                      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Container(
                                            width: 200,
                                            child: Text(
                                              '${state.loadedLesson[index]?.title ?? "Неизвестно"}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Theme.of(context).textTheme.labelMedium?.color,
                                                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                        FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Container(
                                            width: 200,
                                            margin: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                            child: Text(
                                              '${state.loadedLesson[index]?.teacherName ?? "Неизвестно"}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Theme.of(context).textTheme.labelMedium?.color,
                                                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                                fontSize: 11,
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
                                          child: Text(
                                            '${state.loadedLesson[index]?.cab ?? "Неизвестно"}',
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.labelMedium?.color,
                                              fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                              fontSize: 10,
                                            ),
                                          ),
                                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                        ),
                                        Container(
                                          child: Text(
                                            '88:88',
                                            style: TextStyle(
                                              color: Theme.of(context).textTheme.labelMedium?.color,
                                              fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                              fontSize: 9,
                                            ),
                                          ),
                                          margin: EdgeInsets.fromLTRB(0, 3, 20, 0),
                                        )
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      )
                  ),
                ),
              ],
            );
          }
          if(state is LessonErrorState) {
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
          return const CupertinoActivityIndicator(
            color: Color(0xFFFFFFFF),
            radius: 10,
          );
        },
    );
  }
}