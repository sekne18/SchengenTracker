import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schengen_tracker/helpers/helpers.dart';
import 'package:schengen_tracker/models/trip.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateSelectionScreen extends StatefulWidget {
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
      return CalendarDatePicker(
          initialDate: _dateTimeNotifier.value,
          firstDate: _dateTimeNotifier.value,
          lastDate: DateTime(DateTime.now().year + 100),
          onDateChanged: (selectedDate) {
            _departure = selectedDate;
          });
    }

    addStringToSF() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int duration = Helpers.daysBetween(_arrive, _departure);
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      final String encodedData = Trip.encode([
        Trip(
          id: dateFormat.format(DateTime.now()),
          arrive: dateFormat.format(_arrive),
          departure: dateFormat.format(_departure),
          duration: duration,
        ),
      ]);
      prefs.setString('listOfTrips', encodedData);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: () {
              addStringToSF();
              Navigator.of(context).pop();
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
