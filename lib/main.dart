import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:schedule_sgk/DAO/group_dao.dart';
import 'package:schedule_sgk/models/group.dart';
import 'package:schedule_sgk/pages/home_page.dart';
import 'package:schedule_sgk/services/database_provider.dart';
import 'package:schedule_sgk/theme/theme.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DAO/cabinet_dao.dart';
import 'DAO/teacher_dao.dart';
import 'models/cabinet.dart';
import 'models/teacher.dart';

late bool theme;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyAfo07k_iYfhQCGnPswrcsZZ7AyCdVkig0',
        appId: '1:900034718663:android:576af5641675410db407e2',
        messagingSenderId: '900034718663',
        projectId: 'schedulesgk')
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await _loadSwitchValue();
  await DatabaseProvider.instance.database;
  GroupDAO().setCashedGroup(List<Group>.empty());
  TeacherDAO().setCashedTeacher(List<Teacher>.empty());
  CabinetDAO().setCashedCabinet(List<Cabinet>.empty());
  runApp(MyApp());
}

_loadSwitchValue() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool savedSwitchValue = sharedPreferences.getBool('theme') ?? false;
  theme = savedSwitchValue;
}

class MyApp extends StatelessWidget {

  static final navigatorKey = GlobalKey<NavigatorState>();
  final ThemeData themeData = !theme ? darkTheme() : whiteTheme();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: themeData,
      home: const HomePage(),
    );
  }
}

