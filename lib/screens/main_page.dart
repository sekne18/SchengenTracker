import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  void updateDaysLeft() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int sum = 0;

    // prefs.remove('listOfTrips');
    // checks for triplist existence
    if (prefs.getString('listOfTrips') == null) {
      return;
    }

    //Gets trips from database
    String? tripsString = prefs.getString('listOfTrips');
    _userTrips = Trip.decode(tripsString!);

    //Gets recent Transactions
    _recentTransactions;

    // gets sum of durations
    for (int i = 0; i < _userTrips.length; i++) {
      sum += _userTrips[i].duration;
    }

    setState(() {
      days_left = days_left - sum;
    });
  }

  List<Trip> get _recentTransactions {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return _userTrips.where((tx) {
      return dateFormat.parse(tx.arrive).isAfter(
            DateTime.now().subtract(
              const Duration(days: 90),
            ),
          );
    }).toList();
  }

  // void _addNewTrip(DateTime arrive, DateTime departure, int duration) {
  //   final newTx = Trip(
  //     id: DateTime.now().toString(),
  //     arrive: arrive,
  //     departure: departure,
  //     duration: duration,
  //   );

  //   setState(() {
  //     _userTrips.add(newTx);
  //   });
  // }

  // void _startAddNewTransaction(BuildContext ctx) {
  //   showModalBottomSheet(
  //     context: ctx,
  //     builder: (_) {
  //       return GestureDetector(
  //         onTap: () {},
  //         child: NewTrip(_addNewTrip),
  //         behavior: HitTestBehavior.opaque,
  //       );
  //     },
  //   );
  // }

  void _deleteTransaction(String id) {
    setState(() {
      _userTrips.removeWhere((element) => element.id == id);
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
              child: Text(
                days_left.toString(),
                style: const TextStyle(
                  fontSize: 68.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                width: 5,
                color: Colors.deepPurple,
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
              onPressed: () => Navigator.pushNamed(context, '/date_selection'),
              child: const Icon(Icons.add),
            ),
          );
  }
}
