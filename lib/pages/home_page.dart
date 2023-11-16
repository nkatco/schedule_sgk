import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_sgk/bloc/cabinet.bloc/cabinet_event.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_bloc.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_event.dart';
import 'package:schedule_sgk/pages/profile_page.dart';
import 'package:schedule_sgk/repositories/cabinet_repository.dart';
import 'package:schedule_sgk/repositories/group_repository.dart';
import 'package:schedule_sgk/widgets/cabinet_dialog.dart';
import 'package:schedule_sgk/widgets/group_list.dart';

import '../bloc/cabinet.bloc/cabinet_bloc.dart';
import '../bloc/teacher.bloc/teacher_bloc.dart';
import '../bloc/teacher.bloc/teacher_event.dart';
import '../repositories/teacher_repository.dart';
import '../widgets/cabinet_list.dart';
import '../widgets/group_dialog.dart';
import '../widgets/teacher_dialog.dart';
import '../widgets/teacher_list.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  final teachersRepository = TeachersRepository();
  final groupRepository = GroupsRepository();
  final cabinetRepository = CabinetsRepository();
  late TeacherBloc _teacherBloc;
  late GroupBloc _groupBloc;
  late CabinetBloc _cabinetsBloc;

  @override
  void initState() {
    super.initState();
    _teacherBloc = TeacherBloc(teacherRepository: teachersRepository);
    _groupBloc = GroupBloc(groupRepository: groupRepository);
    _cabinetsBloc = CabinetBloc(cabinetRepository: cabinetRepository);
    _tabController = TabController(length: 3, vsync: this);

    _groupBloc.add(GroupLoadEvent());
    _teacherBloc.add(TeacherLoadEvent());
    _cabinetsBloc.add(CabinetLoadEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _teacherBloc.close();
    _cabinetsBloc.close();
    _groupBloc.close();
    super.dispose();
  }

  void navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
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

  void _showDialog() {
    int selectedIndex = _tabController.index;
    if(selectedIndex == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return GroupDialog(groupBloc: _groupBloc,);
        },
      );
    } else if (selectedIndex == 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TeacherDialog(teacherBloc: _teacherBloc,);
        },
      );
    } else if (selectedIndex == 2) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CabinetDialog(cabinetBloc: _cabinetsBloc,);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    return MultiBlocProvider(
        providers: [
          BlocProvider<TeacherBloc>(create: (BuildContext context) => _teacherBloc),
          BlocProvider<GroupBloc>(create: (BuildContext context) => _groupBloc),
          BlocProvider<CabinetBloc>(create: (BuildContext context) => _cabinetsBloc),
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 1,
            toolbarHeight: ScreenUtil().setHeight(150),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {
                              _showDialog();
                            },
                            icon: Image.asset('assets/glass.png', width: ScreenUtil().setWidth(10), height: ScreenUtil().setHeight(10)),
                            label: Text('Поиск', style: TextStyle(
                                color: Theme.of(context).textTheme.labelMedium?.color,
                                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                fontSize: ScreenUtil().setSp(10)
                            ),
                            )
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(15), 0, 0, 0),
                      child: Image.asset(
                        'assets/logo.png',
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(100),
                      ),
                    ),
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            navigateToProfile(context);
                          },
                          label: Row(
                            children: [
                              Text('Профиль', style: TextStyle(
                                  color: Theme.of(context).textTheme.labelMedium?.color,
                                  fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                  fontSize: ScreenUtil().setSp(10)
                              ),
                              ),
                              SizedBox(width: ScreenUtil().setWidth(4)),
                              Image.asset('assets/person.png', width: ScreenUtil().setWidth(10), height: ScreenUtil().setHeight(10)),
                            ],
                          ),
                          icon: SizedBox(width: 0, height: 0),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, ScreenUtil().setHeight(25)),
                  padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(child: Text('Группа',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium?.color,
                            fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                            fontSize: ScreenUtil().setSp(10)
                        ),
                      ),
                      ),
                      Tab(child: Text('Преподаватель',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium?.color,
                            fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                            fontSize: ScreenUtil().setSp(10)
                        ),
                      ),
                      ),
                      Tab(child: Text('Кабинет',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium?.color,
                            fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                            fontSize: ScreenUtil().setSp(10)
                        ),
                      ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              GroupList(),
              TeacherList(),
              CabinetList(),
            ],
          ),
        )
    );
  }
}
