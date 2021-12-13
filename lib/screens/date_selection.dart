import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schengen_tracker/helpers/helpers.dart';
import 'package:schengen_tracker/models/trip.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({Key? key}) : super(key: key);

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  final ValueNotifier<DateTime> _dateTimeNotifier =
      ValueNotifier<DateTime>(DateTime.now());
  DateTime _arrive = DateTime.now();
  DateTime _departure = DateTime.now();

  int? duration;

  @override
  Widget build(BuildContext context) {
    Widget _buildDepartureCalendar() {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Colors.teal, // header background color
          ),
        ),
        child: CalendarDatePicker(
            initialDate: _dateTimeNotifier.value.add(
              const Duration(days: 1),
            ),
            firstDate: _dateTimeNotifier.value.add(
              const Duration(days: 1),
            ),
            lastDate: DateTime(DateTime.now().year + 100),
            onDateChanged: (selectedDate) {
              _departure = selectedDate;
            }),
      );
    }

    // Future<dynamic> _showDialog(BuildContext context) {
    //   return showDialog(
    //       context: context,
    //       builder: (BuildContext context) {
    //         return AlertDialog(
    //           title: const Text("Dates in use"),
    //           content: const Text("You have already used these dates."),
    //           shape: const CircleBorder(),
    //           actions: <Widget>[
    //             TextButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: const Text("Ok"),
    //             ),
    //           ],
    //         );
    //       });
    // }

    addStringToSF() async {
      int duration = Helpers.daysBetween(_arrive, _departure);
      DateFormat dateFormat = DateFormat.yMMMMd();

      String? tripsString = Helpers.prefs.getString('listOfTrips');
      List<Trip> _userTrips;
      final String encodedData;

      if (tripsString != null) {
        List<Trip> _userTrips = Trip.decode(tripsString);
        bool used = false;
        for (int i = 0; i < _userTrips.length; i++) {
          DateTime startDate = DateTime.parse(_userTrips[i].arrive);
          DateTime endDate = DateTime.parse(_userTrips[i].departure);
          if (!((_arrive.isBefore(startDate) ||
                  _arrive.isAfter(endDate.subtract(const Duration(days: 1)))) &&
              (_departure.isBefore(startDate) ||
                  _departure.isAfter(endDate)))) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Dates in use"),
                    content: const Text("You have already used these dates."),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Ok"),
                      ),
                    ],
                  );
                });
            return; // Date not usable
          }
        }
        _userTrips.add(Trip(
          id: _arrive.toString(),
          arrive: _arrive.toString(),
          departure: _departure.toString(),
          duration: duration,
        ));
        encodedData = Trip.encode(_userTrips);
        Helpers.prefs.setString('listOfTrips', encodedData);
      } else {
        encodedData = Trip.encode([
          Trip(
            id: _arrive.toString(),
            arrive: _arrive.toString(),
            departure: _departure.toString(),
            duration: duration,
          ),
        ]);
        Helpers.prefs.setString('listOfTrips', encodedData);
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: () {
              addStringToSF();
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Card(
                elevation: 7,
                margin: const EdgeInsets.all(15),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Colors.teal, // header background color
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _dateTimeNotifier.value,
                    firstDate: DateTime(DateTime.now().year - 100),
                    lastDate: DateTime(2101),
                    onDateChanged: (selectedDate) {
                      _arrive = selectedDate;
                      _dateTimeNotifier.value = selectedDate;
                      setState(() {
                        _buildDepartureCalendar();
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Card(
                elevation: 7,
                margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                child: _buildDepartureCalendar(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
