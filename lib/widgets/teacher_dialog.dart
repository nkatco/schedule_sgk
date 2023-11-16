import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/bloc/teacher.bloc/teacher_bloc.dart';
import 'package:schedule_sgk/widgets/search/teacher_search_list.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/teacher.bloc/teacher_event.dart';

class TeacherDialog extends StatelessWidget {
  final TeacherBloc teacherBloc;

  const TeacherDialog({Key? key, required this.teacherBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: teacherBloc,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          teacherBloc.add(TeacherLoadEvent());
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Card(
                elevation: 5,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15.w, 10.h, 15.w, 15.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).cardColor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: Image.asset(
                                    'assets/glass.png',
                                    width: 15.w,
                                    height: 15.h,
                                  ),
                                  padding: EdgeInsets.fromLTRB(15.w, 0.h, 0.w, 0.h),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10.w, 0.h, 0.w, 0.h),
                                    child: TextField(
                                      onChanged: (searchTerm) {
                                        teacherBloc.add(TeacherSearchEvent(searchTerm: searchTerm));
                                      },
                                      style: TextStyle(
                                        fontFamily: Theme.of(context).textTheme.bodyText1?.fontFamily,
                                        color: Theme.of(context).textTheme.labelMedium?.color,
                                        fontSize: 13.sp,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Поиск',
                                        hintStyle: TextStyle(
                                          fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF9E9E9E),
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 230.w,
                        height: 220.h,
                        child: TeacherSearchList(),
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
