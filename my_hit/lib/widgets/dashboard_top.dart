import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/auth.dart';

class DashboardTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context);
    return Stack(
      children: <Widget>[
        Container(
          height: deviceSize.size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/hitbg.jpg"),
                  fit: BoxFit.cover),
              borderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(60.0))),
        ),
        Container(
            height: deviceSize.size.height * 0.4,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(60.0)),
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Color(0xffFFB400).withOpacity(0.8)
                    ])),
            child: FutureBuilder(
                future:
                    Provider.of<UserProvider>(context, listen: false).getUser(),
                builder: (ctx, dataSnapShot) {
                  if (dataSnapShot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapShot.error != null) {
                      return Center(
                        child: Text('An error occurred!'),
                      );
                    } else {
                      return Consumer<UserProvider>(
                        child: Center(
                          child: Text(
                            'No User Infomation Found.',
                            style: TextStyle(
                                fontFamily: 'Oxygen',
                                fontSize: 30.0,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        builder: (ctx, user, ch) => Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.power_settings_new),
                                  color: Colors.white,
                                  onPressed: () {
                                    Provider.of<Auth>(context, listen: false)
                                        .logout();
                                  },
                                )
                              ],
                            ),
                            Center(
                              child: CircleAvatar(
                                // backgroundColor: Colors.red,
                                backgroundImage:
                                    NetworkImage(user.userWacho.imageUrl),
                                // AssetImage('assets/images/admin.jpg'),
                                radius: deviceSize.orientation ==
                                        Orientation.portrait
                                    ? 60.0
                                    : 20.0,
                              ),
                            ),
                            SizedBox(height: deviceSize.size.height * 0.02),
                            Text(
                              user.userWacho.firstName.toUpperCase() +
                                  " " +
                                  user.userWacho.lastName.toUpperCase(),
                              // 'Melisa Ruvimbo Ruzawe',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 25.0),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: deviceSize.size.height * 0.02),
                            Text(
                              user.userWacho.studentNumber,
                              // 'H160157F',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }
                  }
                }))
      ],
    );
  }
}
