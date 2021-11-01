import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schengen_tracker/models/trip.dart';
import 'package:schengen_tracker/widgets/new_trip.dart';
import 'package:schengen_tracker/widgets/trip_list.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  final List<Trip> _userTrips = [];
  int days_left = 0;

  List<Trip> get _recentTransactions {
    return _userTrips.where((tx) {
      return tx.arrive.isAfter(
        DateTime.now().subtract(
          Duration(days: 90),
        ),
      );
    }).toList();
  }

  void _addNewTrip(DateTime arrive, DateTime departure, int duration) {
    final newTx = Trip(
      id: DateTime.now().toString(),
      arrive: arrive,
      departure: departure,
      duration: duration,
    );

    setState(() {
      _userTrips.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTrip(_addNewTrip),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

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
        //  margin: EdgeInsets.only(top: 33),
        padding: EdgeInsets.only(bottom: 20),
      ),
      txListWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            actions: <Widget>[
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              ),
            ],
          ) as PreferredSizeWidget;
    final txListWidget = Container(
      child: TripList(_userTrips, _deleteTransaction),
    );
    final pageBody = SafeArea(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            width: 200,
            height: 200,
            child: const Center(
              child: Text(
                "90",
                style: TextStyle(
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
              child: Icon(Icons.add),
            ),
          );
  }
}
