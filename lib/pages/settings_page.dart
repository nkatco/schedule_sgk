import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_sgk/bloc/theme.bloc/theme_event.dart';
import 'package:schedule_sgk/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/theme.bloc/theme_bloc.dart';
import '../bloc/theme.bloc/theme_state.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late bool switchValue = false;
  late ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc();
    _themeBloc.add(LoadTheme());
  }

  @override
  void dispose() {
    _themeBloc.close();
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
    ScreenUtil.init(context);

    return BlocProvider<ThemeBloc>(
      create: (context) => _themeBloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is ThemeUpdated) {
            switchValue = state.newTheme;
          }
          if (state is ThemeLoaded) {
            switchValue = state.newTheme;
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: ScreenUtil().setHeight(100),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(48),
                    height: ScreenUtil().setHeight(34),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      onPressed: () {
                        navigateToProfile(context);
                      },
                      icon: Image.asset('assets/back.png',
                          width: ScreenUtil().setWidth(14),
                          height: ScreenUtil().setHeight(14)),
                    ),
                  ),
                  Text(
                    'Настройки',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.labelMedium?.color,
                      fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                      fontSize: ScreenUtil().setSp(13.5),
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(50),
                    height: ScreenUtil().setHeight(38),
                  )
                ],
              ),
            ),
            body: Column(
              children: [
                Center(
                  child: Container(
                    height: ScreenUtil().setHeight(60),
                    margin: EdgeInsets.fromLTRB(
                        ScreenUtil().setWidth(20),
                        ScreenUtil().setHeight(20),
                        ScreenUtil().setWidth(20),
                        0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              ScreenUtil().setWidth(20),
                              0,
                              0,
                              0),
                          child: Text(
                            'Тема',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.labelMedium?.color,
                              fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                              fontSize: ScreenUtil().setSp(14),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              0,
                              0,
                              ScreenUtil().setWidth(10),
                              0),
                          child: Switch(
                              value: switchValue,
                              onChanged: (value) {
                                setState(() {
                                  _themeBloc.add(ToggleTheme());
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
