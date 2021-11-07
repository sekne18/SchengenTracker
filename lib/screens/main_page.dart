import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:schengen_tracker/helpers/helpers.dart';
import 'package:schengen_tracker/models/trip.dart';
import 'package:schengen_tracker/widgets/trip_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  List<Trip> _userTrips = [];
  int days_left = 90;

  // Loops throught valid trips and sums duration for each trip and then save it to daysLeft
  void updateDaysLeft() {
    int sum = 0;
    // gets sum of durations
    for (int i = 0; i < _userTrips.length; i++) {
      sum += _userTrips[i].duration;
    }
    days_left = Helpers.lengthOfSchengen - sum;
  }

  Future<List<Trip>> get _recentTransactions async {
    DateFormat dateFormat = DateFormat.yMMMMd();

    // checks for listOfTrips existence
    if (Helpers.prefs.getString('listOfTrips') != null) {
      String? tripsString = Helpers.prefs.getString('listOfTrips');
      _userTrips = Trip.decode(tripsString!);
    }
    List<Trip> tmp = _userTrips;
    _userTrips = [];
    //Gets trips from database that are within 90
    return _userTrips = tmp.where((tx) {
      return dateFormat.parse(tx.arrive).isAfter(
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
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            width: 200,
            height: 200,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  days_left.toString(),
                  style: const TextStyle(
                    fontSize: 68.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 5,
                color: Colors.teal,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(200),
              ),
              color: Colors.transparent,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ..._buildPortraitContent(
                  txListWidget,
                ),
              ],
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
