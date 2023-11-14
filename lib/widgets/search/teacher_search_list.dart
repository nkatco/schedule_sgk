import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_bloc.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_state.dart';
import 'package:intl/intl.dart';

import '../../models/teacher.dart';
import '../../pages/lessons_page.dart';

class TeacherSearchList extends StatelessWidget {
  const TeacherSearchList({super.key});

  void navigateToLesson(BuildContext context, Teacher teacher) {
    DateTime currentDate = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            LessonsPage(item: teacher, date: formattedDate),
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
        if (state is TeacherEmptyState) {
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
        if (state is TeacherLoadingState) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is TeacherLoadedState) {
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            itemCount: state.loadedTeacher.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                navigateToLesson(context, state.loadedTeacher[index]);
              },
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: Text(
                        '${state.loadedTeacher[index]?.name ?? "Unknown"}',
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
            ),
          );
        }
        if (state is TeacherErrorState) {
          return Center(
            child: Text(
              'Error: ${state.errorText}',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: 14,
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
