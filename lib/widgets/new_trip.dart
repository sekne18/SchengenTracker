// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class NewTrip extends StatefulWidget {
//   final Function addTx;

//   NewTrip(this.addTx);

//   @override
//   State<NewTrip> createState() => _NewTripState();
// }

// class _NewTripState extends State<NewTrip> {
//   DateTime? _arrive;
//   DateTime? _departure;
//   int? duration;

//   void _submitData() {
//     if (_departure == null || _arrive == null) {
//       return;
//     }
//     duration = daysBetween(_arrive!, _departure!);
//     widget.addTx(
//       _arrive,
//       _departure,
//       duration,
//     );

//     Navigator.of(context).pop(); // Closes keyboard
//   }

  

//   // void _presentDatePicker() {
//   //   showDatePicker(
//   //     context: context,
//   //     initialDate: DateTime.now(),
//   //     firstDate: DateTime(2019),
//   //     lastDate: DateTime.now(),
//   //   ).then((pickedDate) {
//   //     if (pickedDate == null) {
//   //       return;
//   //     }
//   //     setState(() {
//   //       _selectedDate = pickedDate;
//   //     });
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Card(
//         elevation: 5,
//         child: Container(
//           padding: EdgeInsets.only(
//             top: 10,
//             left: 10,
//             right: 10,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 10,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Container(
//                 height: 70,
//                 child: Row(
//                   children: [
//                     CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year), lastDate: DateTime.now(), onDateChanged: (_) {}),
//                     CalendarDatePicker(initialDate: DateTime.now(), firstDate: DateTime(DateTime.now().year), lastDate: DateTime.now(), onDateChanged: (_) {}),
//                     // AdaptiveFlatButton('Choose Date', _presentDatePicker),
//                   ],
//                 ),
//               ),
//               RaisedButton(
//                 onPressed: _submitData,
//                 child: const Text('Add transaction'),
//                 textColor: Theme.of(context).textTheme.button!.color,
//                 color: Theme.of(context).primaryColor,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }