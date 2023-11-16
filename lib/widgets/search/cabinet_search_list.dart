import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cabinet.bloc/cabinet_bloc.dart';
import '../../bloc/cabinet.bloc/cabinet_state.dart';
import '../../models/cabinet.dart';
import '../../pages/lessons_page.dart';

class CabinetSearchList extends StatelessWidget {
  const CabinetSearchList({Key? key});

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
    return BlocBuilder<CabinetBloc, CabinetState>(
      builder: (context, state) {
        if (state is CabinetEmptyState) {
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
        if (state is CabinetLoadingState) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(16.sp),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is CabinetLoadedState) {
          return ListView.builder(
            padding: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
            itemCount: state.loadedCabinet.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                navigateToLesson(context, state.loadedCabinet[index]);
              },
              child: Column(
                children: [
                  Container(
                    height: 45.h,
                    width: 220.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h),
                    child: Center(
                      child: Text(
                        '${state.loadedCabinet[index]?.name ?? "Unknown"}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelMedium?.color,
                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                          fontSize: 12.sp,
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
        if (state is CabinetErrorState) {
          return Center(
            child: Text(
              'Error: ${state.errorText}',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: 14.sp,
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
