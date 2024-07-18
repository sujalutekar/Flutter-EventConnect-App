import 'package:flutter/material.dart';

/* 
  todo
  - change hintcolor
  - change appbartheme
*/

class AppThemes {
  static final lightTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white60,
    ),
    primaryColor: Colors.deepOrange,
    cardColor: Colors.grey.shade200,
    hintColor: Colors.deepPurpleAccent,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    // appBarTheme: const AppBarTheme(
    //   color: Colors.teal,
    // ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.deepOrange),
  );

  static final darkTheme = ThemeData(
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.black26,
    ),
    primaryColor: Colors.deepOrange,
    cardColor: Colors.grey.shade900,
    hintColor: Colors.deepPurpleAccent,
    scaffoldBackgroundColor: const Color.fromARGB(255, 24, 23, 23),
    brightness: Brightness.dark,
    // appBarTheme: const AppBarTheme(
    //   color: Colors.teal,
    // ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    buttonTheme: const ButtonThemeData(buttonColor: Colors.deepOrange),
  );
}
