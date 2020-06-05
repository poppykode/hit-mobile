import 'package:flutter/material.dart';

class ShowErrorDialog extends StatelessWidget {
  final String message;
  ShowErrorDialog(this.message);
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );

  }
}