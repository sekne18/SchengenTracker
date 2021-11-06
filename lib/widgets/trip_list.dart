import 'package:flutter/material.dart';
import 'package:schengen_tracker/models/trip.dart';

import 'trip_item.dart';

class TripList extends StatelessWidget {
  final List<Trip> trips;
  final Function deleteTx;

  TripList(
    this.trips,
    this.deleteTx,
  );

  @override
  Widget build(BuildContext context) {
    return trips.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No trips added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            );
          })
        : ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: trips
                .map((tx) => TripItem(
                      key: ValueKey(tx.id),
                      deleteTx: deleteTx,
                      trip: tx,
                    ))
                .toList(),
          );
  }
}
