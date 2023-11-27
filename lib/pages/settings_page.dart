import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_sgk/bloc/theme.bloc/theme_event.dart';
import 'package:schedule_sgk/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/theme.bloc/theme_bloc.dart';
import '../bloc/theme.bloc/theme_state.dart';
import '../widgets/item_selection_widget.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late bool switchValue = false;
  late ThemeBloc _themeBloc;
  late double _position = 0.0;
  late double _startPosition = 0.0;

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
          return GestureDetector(
              onHorizontalDragStart: (details) {
                _startPosition = details.globalPosition.dx;
              },
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _position = details.globalPosition.dx - _startPosition;
                });
              },
              onHorizontalDragEnd: (details) {
                if (_position > MediaQuery.of(context).size.width / 2) {
                  setState(() {
                    _position = 0.0;
                  });
                  navigateToProfile(context);
                } else {
                  setState(() {
                    _position = 0.0;
                  });
                }
              },
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  transform: Matrix4.translationValues(_position, 0.0, 0.0),
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      toolbarHeight: ScreenUtil().setHeight(100),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: ScreenUtil().setWidth(44),
                            height: ScreenUtil().setHeight(30),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                navigateToProfile(context);
                              },
                              icon: Image.asset('assets/back.png',
                                  width: ScreenUtil().setWidth(10),
                                  height: ScreenUtil().setHeight(10)),
                            ),
                          ),
                          Text(
                            'Настройки',
                            style: TextStyle(
                              color: Theme.of(context).textTheme.labelMedium?.color,
                              fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                              fontSize: ScreenUtil().setSp(11),
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
                                      fontSize: ScreenUtil().setSp(11),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      ScreenUtil().setWidth(11),
                                      0),
                                  child: Switch(
                                      value: switchValue,
                                      materialTapTargetSize: MaterialTapTargetSize.padded,
                                      onChanged: (value) {
                                        setState(() {
                                          _themeBloc.add(ToggleTheme());
                                        });
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
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
                                    'Виджет',
                                    style: TextStyle(
                                      color: Theme.of(context).textTheme.labelMedium?.color,
                                      fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                                      fontSize: ScreenUtil().setSp(11),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => ItemSelectionWidget(),
                                    );
                                  },
                                  icon: Image.asset('assets/settings.png',
                                      width: ScreenUtil().setWidth(15),
                                      height: ScreenUtil().setHeight(15)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              )
          );
        },
      ),
    );
  }
}
