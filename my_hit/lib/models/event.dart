import 'package:flutter/material.dart';

class Event {
  final int id;
  final String name;
  final String descrption;
  final DateTime date;
  final String location;
   final String imageUrl;
  Event(
      {@required this.id,
      @required this.name,
      @required this.descrption,
      @required this.date,
      @required this.location,
      @required this.imageUrl});
}
