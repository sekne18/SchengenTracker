import 'package:flutter/material.dart';
import 'package:schengen_tracker/screens/date_selection.dart';

import 'screens/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schengen Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.deepPurple,
        accentColor: Colors.deepPurple[300],
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
              subtitle1: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/date_selection': (context) => DateSelectionScreen(),
      },
    );
  }
}
