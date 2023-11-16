import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_bloc.dart';
import 'package:schedule_sgk/models/teacher.dart';
import 'package:schedule_sgk/pages/lessons_page.dart';
import 'package:schedule_sgk/DAO/teacher_dao.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_event.dart';
import 'package:schedule_sgk/repositories/favorites_repository.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/teacher.bloc/teacher_state.dart';

class TeacherList extends StatelessWidget {
  final FavoritesRepository favoritesRepository = FavoritesRepository();
  final TeacherDAO teacherDAO = TeacherDAO();

  TeacherList({Key? key});

  void navigateToLesson(BuildContext context, Teacher teacher) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LessonsPage(item: teacher, date: formattedDate),
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
    return BlocBuilder<TeacherBloc, TeacherState>(
      builder: (context, state) {
        final TeacherBloc teacherBloc = context.read<TeacherBloc>();
        if (state is TeacherEmptyState) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: 14.sp,
              ),
            ),
          );
        }
        if (state is TeacherLoadingState) {
          return Center(
            child: CupertinoActivityIndicator(
              radius: 10.w,
            ),
          );
        }
        if (state is TeacherLoadedState) {
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(0.w, 15.h, 0.w, 0.h),
            itemCount: state.loadedTeacher.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                navigateToLesson(context, state.loadedTeacher[index]);
              },
              child: Column(
                children: [
                  InkResponse(
                    onLongPress: () {
                      if (state.loadedTeacher[index].favorite == true) {
                        state.loadedTeacher[index].favorite = false;
                        favoritesRepository.deleteFavorite(state.loadedTeacher[index]!.id.toString());
                      } else {
                        state.loadedTeacher[index].favorite = true;
                        favoritesRepository.insertFavorite(state.loadedTeacher[index]!.id.toString());
                      }
                      teacherDAO.modifyFavoriteTeacher(state.loadedTeacher[index]);
                      teacherBloc.add(TeacherLoadEvent());
                    },
                    onTap: () {
                      navigateToLesson(context, state.loadedTeacher[index]);
                    },
                    child: Container(
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0.h),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${state.loadedTeacher[index]?.name ?? "Неизвестно"}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.labelMedium?.color,
                                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                fontSize: 12.sp,
                              ),
                            ),
                            if (state.loadedTeacher[index]?.favorite == true)
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
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          );
        }
        if (state is TeacherErrorState) {
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
          radius: 15.w,
        );
      },
    );
  }
}
