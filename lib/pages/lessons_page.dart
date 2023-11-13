import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:schedule_sgk/bloc/lesson.bloc/lesson_bloc.dart';
import 'package:schedule_sgk/models/item.dart';
import 'package:schedule_sgk/pages/home_page.dart';
import 'package:schedule_sgk/repositories/lesson_repository.dart';
import 'package:schedule_sgk/widgets/lessons_list.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../bloc/lesson.bloc/lesson_event.dart';


class LessonsPage extends StatefulWidget {

  final Item item;
  final String date;

  const LessonsPage({super.key, required this.item, required this.date});

  @override
  _LessonsPageState createState() => _LessonsPageState(item: item, date: date);
}

class _LessonsPageState extends State<LessonsPage> with SingleTickerProviderStateMixin {

  final lessonRepository = LessonsRepository();
  late LessonBloc _lessonBloc;

  final Item item;
  String date;

  _LessonsPageState({required this.item, required this.date});

  @override
  void initState() {
    _lessonBloc = LessonBloc(lessonRepository: lessonRepository);
    _lessonBloc.add(LessonLoadEvent(item: item, date: date));
    super.initState();
  }

  @override
  void dispose() {
    _lessonBloc.close();
    super.dispose();
  }

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
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

  Future<void> _selectDate(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext builderContext) {
        return Container(
          height: 300,
          child: SfDateRangePicker(
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              Navigator.of(context).pop();
              _onSelectionChanged(args);
            },
            selectionMode: DateRangePickerSelectionMode.single,
            initialSelectedDate: DateTime.parse(date),
          ),
        );
      },
    );
  }
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        date = DateFormat('yyyy-MM-dd').format(args.value as DateTime);
      } else if (args.value is PickerDateRange) {
        date = DateFormat('yyyy-MM-dd').format((args.value as PickerDateRange).startDate!);;
      }
    });

    _lessonBloc.add(LessonLoadEvent(item: item, date: date));
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LessonBloc>(
        create: (BuildContext context) => _lessonBloc,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 100,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      navigateToHome(context);
                    },
                    icon: Image.asset('assets/back.png', width: 12, height: 12),
                    label: Text('На главную', style: TextStyle(
                        color: Theme.of(context).textTheme.labelMedium?.color,
                        fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                        fontSize: 12
                    ),
                    )
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _selectDate(context);
                      },
                      label: Row(
                        children: [
                          Text(formatDateTime(DateTime.parse(date)), style: TextStyle(
                              color: Theme.of(context).textTheme.labelMedium?.color,
                              fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                              fontSize: 12
                          ),
                          ),
                          const SizedBox(width: 4),
                          Image.asset('assets/calendar.png', width: 12, height: 12),
                        ],
                      ),
                      icon: const SizedBox(width: 0, height: 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: Container(
            child: LessonList(author: item.getAuthor()),
          ),
        )
    );
  }
}