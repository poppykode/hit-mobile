import 'package:flutter/material.dart';

class Accomodation {
  final int id;
  final String name;
  final int price;
  final int availableSpaces;

  Accomodation(
      {@required this.id,
      @required this.name,
      @required this.price,
      @required this.availableSpaces,
  });
}

class Booking {
  final int id;
  final int accomodation;
  final String accommodationName;
  final String studentNumber;
  final DateTime bookingDate;
  final String price;

  Booking(
      {@required this.id,
        @required this.accomodation,
      @required this.accommodationName,
      @required this.studentNumber,
      @required this.bookingDate,
      @required this.price,
  });
}

