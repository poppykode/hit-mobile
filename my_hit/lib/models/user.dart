import 'package:flutter/material.dart';

class User {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;
  final String studentNumber;
  
  User({
    @required this.username,
    @required this.firstName,
    @required this.email,
    @required this.imageUrl,
    @required this.lastName,
     @required this.studentNumber,
  });
}
