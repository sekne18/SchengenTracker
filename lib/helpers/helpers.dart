import 'package:shared_preferences/shared_preferences.dart';

class Helpers {
  static int lengthOfSchengen = 90;
  static late final SharedPreferences prefs;
  static Future<SharedPreferences> initPrefs() async =>
      prefs = await SharedPreferences.getInstance();

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
