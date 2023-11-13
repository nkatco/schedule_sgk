import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schedule_sgk/bloc/group.bloc/group_bloc.dart';
import 'package:schedule_sgk/pages/profile_page.dart';
import 'package:schedule_sgk/repositories/cabinet_repository.dart';
import 'package:schedule_sgk/repositories/group_repository.dart';
import 'package:schedule_sgk/widgets/group_list.dart';

import '../bloc/cabinet.bloc/cabinet_bloc.dart';
import '../bloc/teacher.bloc/teacher_bloc.dart';
import '../repositories/teacher_repository.dart';
import '../widgets/cabinet_list.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<TeacherBloc>(create: (BuildContext context) => _teacherBloc),
          BlocProvider<GroupBloc>(create: (BuildContext context) => _groupBloc),
          BlocProvider<CabinetBloc>(create: (BuildContext context) => _cabinetsBloc),
        ],
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 150,
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset('assets/glass.png', width: 12, height: 12),
                            label: Text('Поиск', style: TextStyle(
                                color: Theme.of(context).textTheme.labelMedium?.color,
                                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                fontSize: 12
                            ),
                            )
                        ),
                      ],
                    ),
                    Image.asset('assets/logo.png', width: 100, height: 100),
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
                                  fontSize: 12
                              ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset('assets/person.png', width: 12, height: 12),
                            ],
                          ),
                          icon: const SizedBox(width: 0, height: 0),
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                  padding: const EdgeInsets.all(5),
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
                            fontSize: 11
                        ),
                      ),
                      ),
                      Tab(child: Text('Преподаватель',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium?.color,
                            fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                            fontSize: 11
                        ),
                      ),
                      ),
                      Tab(child: Text('Кабинет',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.labelMedium?.color,
                            fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                            fontSize: 11
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
            children: const [
              GroupList(),
              TeacherList(),
              CabinetList(),
            ],
          ),
        )
    );
  }
}