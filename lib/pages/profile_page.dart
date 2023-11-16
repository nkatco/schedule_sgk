import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:schedule_sgk/pages/home_page.dart';
import 'package:schedule_sgk/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void navigateToMain(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));
          var fadeAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            SettingsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve));
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

    return Scaffold(
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
                  navigateToMain(context);
                },
                icon: Image.asset('assets/back.png',
                    width: ScreenUtil().setWidth(10),
                    height: ScreenUtil().setHeight(10)),
              ),
            ),
            Text(
              'Профиль',
              style: TextStyle(
                color: Theme.of(context).textTheme.labelMedium?.color,
                fontFamily: Theme.of(context).textTheme.labelMedium?.fontFamily,
                fontSize: ScreenUtil().setSp(10.5),
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(44),
              height: ScreenUtil().setHeight(30),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: () {
                  navigateToSettings(context);
                },
                icon: Image.asset(
                  'assets/settings.png',
                  width: ScreenUtil().setWidth(10),
                  height: ScreenUtil().setHeight(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
