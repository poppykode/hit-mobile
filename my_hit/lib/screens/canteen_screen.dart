import 'package:flutter/material.dart';

class CanteenScreen extends StatefulWidget {
  static const String namedRoute = '/canteen-screen';
  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Canteen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text("Canteen"),
      ),
    );
  }
}
