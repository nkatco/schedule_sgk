import 'package:flutter/material.dart';
import 'constants.dart';

ThemeData darkTheme() => ThemeData(
  primaryColor: darkPrimaryColor,
  scaffoldBackgroundColor: darkPrimaryColor,
  cardColor: darkCardColor,
    tabBarTheme: TabBarTheme(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return darkSecondaryColor;
        },
      ),
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          shape: BoxShape.rectangle,
          color: darkTabColor
      ),
    ),
    textTheme: const TextTheme(
      labelMedium: TextStyle(
        fontFamily: 'IOSFont-Medium',
        color: darkTextColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return darkCardColorPressed;
                } else {
                  return darkCardColor;
                }
              },
            )
        )
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return darkCardColorPressed;
                } else {
                  return darkCardColor;
                }
              },
            )
        )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return darkCardColorPressed;
                } else {
                  return darkCardColor;
                }
              },
            )
        )
    ),
    appBarTheme: const AppBarTheme(
        color: darkAppBarColor
    ),
  indicatorColor: darkTextColor,
);

ThemeData whiteTheme() => ThemeData(
    primaryColor: whitePrimaryColor,
    scaffoldBackgroundColor: whitePrimaryColor,
    cardColor: whitePrimaryColor,
    tabBarTheme: TabBarTheme(
      overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return whiteSecondaryColor;
        },
      ),
      indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          shape: BoxShape.rectangle,
          color: whiteTabColor
      ),
    ),
    textTheme: const TextTheme(
      labelMedium: TextStyle(
        fontFamily: 'IOSFont-Medium',
        color: whiteTextColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return whiteCardColorPressed;
                } else {
                  return whiteCardColor;
                }
              },
            )
        )
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return whiteCardColorPressed;
                } else {
                  return whiteCardColor;
                }
              },
            )
        )
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return whiteCardColorPressed;
                } else {
                  return whiteCardColor;
                }
              },
            )
        )
    ),
    appBarTheme: const AppBarTheme(
        color: whiteAppBarColor
    ),
    indicatorColor: whiteTextColor,
);