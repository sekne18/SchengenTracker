import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schengen_tracker/helpers/helpers.dart';
import 'package:schengen_tracker/screens/date_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Helpers.initPrefs();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Schengen Tracker',
      theme: ThemeData(
        backgroundColor: Colors.teal,
        fontFamily: 'Nunito',
        colorScheme: const ColorScheme.dark(),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/date_selection': (context) => const DateSelectionScreen(),
      },
    );
  }
}
