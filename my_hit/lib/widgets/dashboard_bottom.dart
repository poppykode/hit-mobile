import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/personal_info_screen.dart';
import '../screens/tabs_screen.dart';
import '../screens/canteen_screen.dart';
import '../screens/timetable_screen.dart';
import '../screens/events_screen.dart';
import '../screens/accommodation_summary_screen.dart';
import '../screens/accomodation_screen.dart';
import '../providers/accomodation_provider.dart';

class DashboardBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context);
    return Column(
      // shrinkWrap: true,
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PersonalInfoScreen()));
          },
          child: Container(
            margin: EdgeInsets.only(top: 15.0),
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  Container(
                      height: deviceSize.size.height * 0.1,
                      width: deviceSize.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xffFFB400),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      child: Icon(
                        Icons.perm_device_information,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: deviceSize.size.width * 0.05,
                  ),
                  Text(
                    'Personal Info',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(TabsScreen.namedRoute);
          },
          child: Container(
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  Container(
                      height: deviceSize.size.height * 0.1,
                      width: deviceSize.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xff00135D),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      child: Icon(
                        Icons.info,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: deviceSize.size.width * 0.05,
                  ),
                  Text(
                    'Queries',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(CanteenScreen.namedRoute);
          },
          child: Container(
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  Container(
                      height: deviceSize.size.height * 0.1,
                      width: deviceSize.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xffFFB400),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      child: Icon(
                        Icons.kitchen,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: deviceSize.size.width * 0.05,
                  ),
                  Text(
                    'Canteen',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(TimetableScreen.namedRoute);
          },
          child: Container(
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  Container(
                      height: deviceSize.size.height * 0.1,
                      width: deviceSize.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xff00135D),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: deviceSize.size.width * 0.05,
                  ),
                  Text(
                    'Timetable',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(EventsScreen.namedRoute);
          },
          child: Container(
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  Container(
                      height: deviceSize.size.height * 0.1,
                      width: deviceSize.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xffFFB400),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      child: Icon(
                        Icons.event,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: deviceSize.size.width * 0.05,
                  ),
                  Text(
                    'Events',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            await Provider.of<AccomodationProvider>(context, listen: false).hasAccomodation()
                ?  Navigator.of(context)
                    .pushNamed(AccommodationSummaryScreen.namedRoute): Navigator.of(context).pushNamed(AccomodationScreen.namedRoute);
                
          },
          child: Container(
            padding: EdgeInsets.only(right: 15.0, left: 15.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      topLeft: Radius.circular(10.0))),
              child: Row(
                children: <Widget>[
                  Container(
                      height: deviceSize.size.height * 0.1,
                      width: deviceSize.size.width * 0.2,
                      decoration: BoxDecoration(
                          color: Color(0xff00135D),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0))),
                      child: Icon(
                        Icons.business,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: deviceSize.size.width * 0.05,
                  ),
                  Text(
                    'Accomodation',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
