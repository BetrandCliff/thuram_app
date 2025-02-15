import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      textTheme: TextTheme(
          displayMedium: TextStyle(fontSize: 16, color: Color(0xff000000)),
          displaySmall: TextStyle(
              fontSize: 14,
              color: Color(0xff000000),
              fontWeight: FontWeight.w400),
          titleMedium: TextStyle(
              fontSize: 25,
              color: Color(0xff000000),
              fontWeight: FontWeight.bold)));
}
