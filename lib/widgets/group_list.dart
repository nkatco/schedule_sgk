import 'package:intl/intl.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_bloc.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/group.dart';
import '../pages/lessons_page.dart';


class GroupList extends StatelessWidget {

  const GroupList({super.key});
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
          if(state is GroupEmptyState) {
            return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.labelMedium?.color,
                    fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                    fontSize: 14,
                  ),
                )
            );
          }
          if(state is GroupLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 10,
              ),
            );
          }
          if(state is GroupLoadedState) {
            return ListView.builder(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                itemCount: state.loadedGroup.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    navigateToLesson(context, state.loadedGroup[index]);
                  },
                  child: Column(
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
                            '${state.loadedGroup[index]?.name ?? "Неизвестно"}',
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
                )
            );
          }
          if (state is GroupErrorState) {

          }
          return const CupertinoActivityIndicator(
            radius: 15,
          );
        },
    );
  }
}