import 'dart:convert';

import 'package:flutter/material.dart';

class Trip {
  final String id;
  final String arrive;
  final String departure;
  final int duration;

  Trip({
    required this.id,
    required this.arrive,
    required this.departure,
    required this.duration,
  });

  factory Trip.fromJson(Map<String, dynamic> jsonData) {
    return Trip(
      id: jsonData['id'],
      arrive: jsonData['arrive'],
      departure: jsonData['departure'],
      duration: jsonData['duration'],
    );
  }

  static Map<String, dynamic> toMap(Trip trip) => {
        'id': trip.id,
        'arrive': trip.arrive,
        'departure': trip.departure,
        'duration': trip.duration,
      };

  static String encode(List<Trip> trips) => json.encode(
        trips.map<Map<String, dynamic>>((trip) => Trip.toMap(trip)).toList(),
      );

  static List<Trip> decode(String trips) =>
      (json.decode(trips) as List<dynamic>)
          .map<Trip>((item) => Trip.fromJson(item))
          .toList();
}
