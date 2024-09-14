import 'package:flutter/material.dart';
class MyTheme{
  static Color primaryColor=const Color(0xff5D9CEC);
  static Color backgroundLight=const Color(0xffDFECDB);
  static Color greenColor=const Color(0xff61E757);
  static Color redColor=const Color(0xffEC4B4B);
  static Color blackColor=const Color(0xff383838);
  static Color whiteColor=const Color(0xffffffff);
  static Color greyColor=const Color(0xff787a7c);

  static ThemeData lightTheme=
  ThemeData(
    primaryColor:primaryColor,
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
    elevation: 0,),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize:22 ,
        fontWeight: FontWeight.bold,
        color:whiteColor
      ),
        titleMedium: TextStyle(
            fontSize:20,
            fontWeight: FontWeight.bold,
            color:blackColor
        ) ,
        titleSmall: TextStyle(
            fontSize:18,
            fontWeight: FontWeight.bold,
            color:blackColor
        )
    ),
    bottomNavigationBarTheme:
    BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.transparent,
      selectedItemColor: primaryColor,
      unselectedItemColor: greyColor
    ),
    floatingActionButtonTheme:
    FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: whiteColor,
          width: 6
        )
      )
    ),
  );
}