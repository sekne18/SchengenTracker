import 'package:flutter/material.dart';

class Trip {
  final String id;
  final DateTime arrive;
  final DateTime departure;
  final int duration;

  Trip({
    required this.id,
    required this.arrive,
    required this.departure,
    required this.duration,
    });

}