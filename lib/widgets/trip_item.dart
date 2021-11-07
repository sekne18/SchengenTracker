import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:schengen_tracker/models/trip.dart';

class TripItem extends StatelessWidget {
  TripItem({
    required this.deleteTx,
    required this.trip,
    required this.key,
  });

  final Key key;
  final Function deleteTx;
  final Trip trip;

  DateFormat dateFormat = DateFormat.yMMMMd();
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 9,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Text(
                      'ARRIVE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateFormat.format(dateFormat.parse(trip.arrive)),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                color: Colors.grey,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const Text(
                      'DEPARTURE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dateFormat.format(dateFormat.parse(trip.departure)),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.more_vert_rounded,
                color: Colors.grey,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    const Text(
                      'Days',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      trip.duration.toString(),
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.teal[500],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        //delete this item
        deleteTx(trip.id);
      },
    );
  }
}
