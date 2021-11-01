
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:schengen_tracker/models/trip.dart';

class TripItem extends StatefulWidget {
  const TripItem({
    Key? key,
    required this.deleteTx,
    required this.trip,
  }) : super(key: key);

  final Function deleteTx;
  final Trip trip;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TripItem> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                textColor: Theme.of(context).errorColor,
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                onPressed: () => widget.deleteTx(widget.trip.id),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.trip.id),
              ),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${widget.trip.duration}'),
            ),
          ),
        ),
        // title: Text(
        //   widget.trip.title,
        //   style: Theme.of(context).textTheme.headline6,
        // ),
        // subtitle: Text(
        //   DateFormat.yMMMd().format(widget.trip.date),
        // ),
      ),
    );
  }
}
