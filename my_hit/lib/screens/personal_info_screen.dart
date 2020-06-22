import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth.dart';

class PersonalInfoScreen extends StatelessWidget {
  static const String namedRoute = '/personal-info-screen';

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context);
    var user = Provider.of<UserProvider>(context, listen: false).userWacho;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              height: deviceSize.size.height * 0.4,
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: <Widget>[
              //    Container(

              //    ),
              //     Column(
              //       children: <Widget>[
              //         Text('Ngoni Mugandai'),
              //         Text('Ngoni Mugandai')
              //       ],
              //     )
              //   ],
              // ),
            ),
            Container(
              margin: EdgeInsets.only(top: 150),
              padding: EdgeInsets.only(right: 20, left: 20),
              height: deviceSize.orientation == Orientation.portrait
                  ? deviceSize.size.height * 0.6
                  : null,
              width: double.infinity,
              child: Card(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.star,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text('Rate Us'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.share,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text('Share'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.question_answer,
                            color: Theme.of(context).accentColor,
                          ),
                          title: Text('Help & Support'),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            color: Theme.of(context).accentColor,
                          ),
                          title: InkWell(
                              onTap: () {
                                Provider.of<Auth>(context, listen: false)
                                    .logout();
                              },
                              child: Text('Logout')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 15.0,
              child: Container(
                padding: EdgeInsets.only(right: 15, left: 15),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Theme.of(context).accentColor,
                      child: Icon(
                        Icons.perm_identity,
                        size: 70,
                        color: Colors.white,
                      ),
                      radius: 50.0,
                    ),
                    SizedBox(
                      width: deviceSize.size.width * 0.03,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.firstName + ' ' + user.lastName,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: deviceSize.size.height * 0.02,
                        ),
                        Text(
                          user.email,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(
                          height: deviceSize.size.height * 0.02,
                        ),
                        Text(
                          user.studentNumber,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
