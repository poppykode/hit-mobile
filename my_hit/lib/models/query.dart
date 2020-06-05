import 'package:flutter/material.dart';

class Query {
  final int id;
  final int departmentId;
  final int userid;
  final String title;
  final String description;
  final DateTime date;
  final String createdBy;
  final String imageUrl;
  Query(
      {@required this.id,
      @required this.departmentId,
      @required this.userid,
      @required this.title,
      @required this.description,
      @required this.date,
      @required this.createdBy,
      @required this.imageUrl,
     });
}
class Response {
    final int id;
    final int query;
    final int commentator;
    final String replyMessage;
    final String fullName;
  Response(
      {@required this.id,
      @required this.query,
      @required this.commentator,
      @required this.replyMessage,
      @required this.fullName
     });
}
