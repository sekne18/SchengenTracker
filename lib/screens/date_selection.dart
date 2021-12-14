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
  DateTime _arrive = DateTime.now();
  DateTime _departure = DateTime.now().add(const Duration(days: 1));
  bool notAvailableDate = false;
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
            initialDate: _departure,
            firstDate: _departure,
            lastDate: DateTime(DateTime.now().year + 100),
            onDateChanged: (selectedDate) {
              _departure = selectedDate;
            }),
      );
    }

    addStringToSF() async {
      int duration = Helpers.daysBetween(_arrive, _departure);
      notAvailableDate = false;
      final String encodedData;
      String? tripsString = Helpers.prefs.getString('listOfTrips');

      if (tripsString != null) {
        List<Trip> _userTrips = Trip.decode(tripsString);

        for (int i = 0; i < _userTrips.length; i++) {
          DateTime startDate = DateTime.parse(_userTrips[i].arrive);
          DateTime endDate = DateTime.parse(_userTrips[i].departure);
          if (!((_arrive.isBefore(startDate) ||
                  _arrive.isAfter(endDate.subtract(const Duration(days: 1)))) &&
              (_departure.isBefore(startDate) ||
                  _departure
                      .isAfter(endDate.subtract(const Duration(days: 1)))))) {
            notAvailableDate = true;
            return;
          }
        }

        _userTrips.add(
          Trip(
            id: _arrive.toString(),
            arrive: _arrive.toString(),
            departure: _departure.toString(),
            duration: duration,
          ),
        );
        encodedData = Trip.encode(_userTrips);
      } else {
        encodedData = Trip.encode(
          [
            Trip(
              id: _arrive.toString(),
              arrive: _arrive.toString(),
              departure: _departure.toString(),
              duration: duration,
            ),
          ],
        );
      }
      Helpers.prefs.setString('listOfTrips', encodedData);
      Navigator.of(context).pop();
    }

    return Container(
      color: const Color(0xff121212),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: TextButton(
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: TextButton(
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          addStringToSF();
                          if (notAvailableDate) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  titleTextStyle: const TextStyle(
                                    color: Colors.teal,
                                  ),
                                  title: const Text("Dates in use"),
                                  content: const Text(
                                      "You have already used these dates."),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        "Ok",
                                        style: TextStyle(
                                          color: Colors.teal,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
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
                    initialDate: _arrive,
                    firstDate: DateTime(DateTime.now().year - 100),
                    lastDate: DateTime(2101),
                    onDateChanged: (selectedDate) {
                      _arrive = selectedDate;
                      _departure = selectedDate.add(const Duration(days: 1));
                      setState(() {
                        _buildDepartureCalendar();
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
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
