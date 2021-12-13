import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:schengen_tracker/helpers/helpers.dart';
import 'package:schengen_tracker/models/trip.dart';
import 'package:schengen_tracker/widgets/trip_list.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  List<Trip> _userTrips = [];
  int _days_left = 90;

  // Loops throught valid trips and sums duration for each trip and then save it to daysLeft
  void updateDaysLeft() {
    int sum = 0;
    // gets sum of durations
    for (int i = 0; i < _userTrips.length; i++) {
      sum += _userTrips[i].duration;
    }
    _days_left = Helpers.lengthOfSchengen - sum;
  }

  Future<List<Trip>> get _recentTransactions async {
    // checks for listOfTrips existence
    if (Helpers.prefs.getString('listOfTrips') != null) {
      String? tripsString = Helpers.prefs.getString('listOfTrips');
      _userTrips = Trip.decode(tripsString!);
    }
    List<Trip> tmp = _userTrips;
    _userTrips = [];
    //Gets trips from database that are within 90 days
    return _userTrips = tmp.where((tx) {
      return DateTime.parse(tx.arrive).isAfter(
        DateTime.now().subtract(
          const Duration(days: 90),
        ),
      );
    }).toList();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTrips.removeWhere((element) => element.id == id);
      String encodedData = Trip.encode(_userTrips);
      Helpers.prefs.setString('listOfTrips', encodedData);
    });
  }

  List<Widget> _buildPortraitContent(
    Widget txListWidget,
  ) {
    return [
      Container(
        padding: const EdgeInsets.only(bottom: 20),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    _recentTransactions;
    updateDaysLeft();
    final txListWidget = TripList(_userTrips, _deleteTransaction);
    final pageBody = SafeArea(
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
                bottomRight: Radius.circular(45),
              ),
            ),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: CircularPercentIndicator(
                radius: 160.0,
                lineWidth: 7.0,
                animationDuration: 1000,
                animation: true,
                percent: _days_left / 90,
                center: Text(
                  "Days left: " + _days_left.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: Colors.white70,
                backgroundColor: Colors.teal[700],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  ..._buildPortraitContent(
                    txListWidget,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
          )
        : Scaffold(
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              elevation: 10,
              onPressed: () => Navigator.pushNamed(context, '/date_selection')
                  .then((_) => setState(() {})),
              child: const Icon(Icons.add),
            ),
          );
  }
}
