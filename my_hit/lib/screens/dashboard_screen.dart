import 'package:flutter/material.dart';
import '../widgets/dashboard_top.dart';
import '../widgets/dashboard_bottom.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DashboardScreen extends StatefulWidget {
   static const String namedRoute = '/dashboard-screen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

   void _showErrorDialog(String message,String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title,style: TextStyle(color:Theme.of(context).accentColor),),
        content: Text(message,style: TextStyle(color:Theme.of(context).accentColor),),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void initState() {
   
    super.initState();
     _firebaseMessaging.getToken().then((token){
   print('FCM Token: $token');
 });
     _firebaseMessaging.configure(
       onMessage: (Map<String, dynamic> message) async {
         print("onMessage: $message");
         final mgs = message["notification"];
         _showErrorDialog(mgs["body"],mgs["title"]);
      
       },
       onLaunch: (Map<String, dynamic> message) async {
         print("onLaunch: $message");
   
       },
       onResume: (Map<String, dynamic> message) async {
         print("onResume: $message");
       },
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   body: SafeArea(
     child:SingleChildScrollView(
          child: Column(
         children: <Widget>[
         DashboardTop(),
         DashboardBottom()
        
         ],
       ),
     )
   ),
      
    );
  }
}