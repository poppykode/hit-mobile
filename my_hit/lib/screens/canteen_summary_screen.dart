import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/canteen_provider.dart';
import '../screens/dashboard_screen.dart';
import '../screens/canteen_buy_meal.dart';

class CanteenSummaryScreen extends StatefulWidget {
  static const String namedRoute = '/canteen-summary-screen';
  @override
  _CanteenSummaryScreenState createState() => _CanteenSummaryScreenState();
}

class _CanteenSummaryScreenState extends State<CanteenSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Canteen Summary',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Card(
          child: FutureBuilder(
              future: Provider.of<CanteenProvider>(context, listen: false)
                  .getSummary(),
              builder: (ctx, snapshoData) {
                if (snapshoData.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshoData.error != null) {
                    return Center(child: Text('Something went wrong.'));
                  } else {
                    return Consumer<CanteenProvider>(
                      child:
                          Center(child: Text('no Canteen information found')),
                      builder: (ctx, can, ch) => can.extractedCanteenData ==
                              null
                          ? Navigator.of(context).pop()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    Text(
                                      'Purchased on: ',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(
                                        DateFormat("yMMMd")
                                            .format(
                                                can.extractedCanteenData.date)
                                            .toString(),
                                        style: TextStyle(fontSize: 25))
                                  ]),
                                  Divider(),
                                  Row(children: <Widget>[
                                    Text('Number of Meals '),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(can.extractedCanteenData.numberOfMeals
                                        .toUpperCase())
                                  ]),
                                  Divider(),
                                  Row(children: <Widget>[
                                    Text('Total Cost'),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text('\$' +
                                        can.extractedCanteenData.totalCost)
                                  ]),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      RaisedButton.icon(
                                        // materialTapTargetSize:
                                        //     MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(35.0)),
                                        color: Theme.of(context).accentColor,
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).popAndPushNamed(
                                              DashboardScreen.namedRoute);
                                        },
                                        label: Text('Back To Main Menu',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      RaisedButton.icon(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(35.0)),
                                        color: Theme.of(context).accentColor,
                                        icon: Icon(
                                          Icons.fastfood,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).popAndPushNamed(
                                              CanteenBuyMealScreen.namedRoute);
                                        },
                                        label: Text('Buy A Meal',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    );
                  }
                }
              }),
        ),
      ),
    );
  }
}
