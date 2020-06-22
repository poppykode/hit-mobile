import 'package:flutter/material.dart';

class Canteen {
  final int id;
  final String numberOfMeals;
  final DateTime date;
  final String totalCost;
  final bool paid;
  Canteen(
      {@required this.id,
      @required this.numberOfMeals,
      @required this.date,
      @required this.totalCost,
      @required this.paid});
}
