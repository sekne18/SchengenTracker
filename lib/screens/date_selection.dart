import 'package:flutter/material.dart';

class DateSelectionScreen extends StatelessWidget {
  DateTime? _arrive;
  DateTime? _departure;
  int? duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.check_rounded),
            onPressed: () {
              //TODO Save trip
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
                margin: EdgeInsets.all(15),
                child: CalendarDatePicker(
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 100),
                  lastDate: DateTime(2101),
                  onDateChanged: (selectedDate) {
                    _arrive = selectedDate;
                  },
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Card(
                  elevation: 7,
                  margin: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  child: CalendarDatePicker(
                      initialDate: DateTime(DateTime.now().year - 100),
                      firstDate: DateTime(201),
                      lastDate: _arrive != null
                          ? _arrive!
                          : DateTime(DateTime.now().year),
                      onDateChanged: (selectedDate) {}),
                )),
          ],
        ),
      ),
    );
  }
}
