import 'package:flutter/material.dart';

class Course {
  final String name;
  final String id;
  Course({@required this.id, @required this.name});
}

class UserTimetable {
  final int courseId;
  final String fileName;
  final String pdf;
  UserTimetable(
      {@required this.courseId, @required this.fileName, @required this.pdf});
}
