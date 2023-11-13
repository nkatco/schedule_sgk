import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_bloc.dart';

class CustomDialog extends StatelessWidget {
  final TeacherBloc teacherBloc;

  const CustomDialog({super.key, required this.teacherBloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: teacherBloc,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Задайте радиус скругления
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 15, 0, 25),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/glass.png',
                              width: 25,
                              height: 25,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Поиск'
                              ),
                            ),
                          ],
                        ),
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