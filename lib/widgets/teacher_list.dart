import 'package:schedule_sgk/bloc/teacher.bloc/teacher_bloc.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherList extends StatelessWidget {
  const TeacherList({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherBloc, TeacherState>(
        builder: (context, state) {
          if(state is TeacherEmptyState) {
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
          if(state is TeacherLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(
                radius: 10,
              ),
            );
          }
          if(state is TeacherLoadedState) {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
              itemCount: state.loadedTeacher.length,
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
                        '${state.loadedTeacher[index]?.name ?? "Неизвестно"}',
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
          if(state is TeacherErrorState) {
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
            radius: 15,
          );
        },
    );
  }
}