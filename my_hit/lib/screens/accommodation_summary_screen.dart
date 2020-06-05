import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/accomodation_provider.dart';

class AccommodationSummaryScreen extends StatefulWidget {
  static const String namedRoute = '/accommodation-summary-screen';

  @override
  _AccommodationSummaryScreenState createState() =>
      _AccommodationSummaryScreenState();
}

class _AccommodationSummaryScreenState
    extends State<AccommodationSummaryScreen> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accomodtion Summary',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Card(
          child: FutureBuilder(
              future: Provider.of<AccomodationProvider>(context, listen: false)
                  .getABooking(),
              builder: (ctx, snapshoData) {
                if (snapshoData.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshoData.error != null) {
                    return Center(child: Text('Something went wrong.'));
                  } else {
                    return Consumer<AccomodationProvider>(
                        child: Center(
                            child: Text('no Accommodaion information found')),
                        builder: (ctx, acc, ch) => acc.extractedBookingData ==
                                null
                            ? Navigator.of(context).pop()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: <Widget>[
                                  Row(children: <Widget>[
                                    Text(
                                      'Booked on: ',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(
                                        DateFormat("yMMMd")
                                            .format(acc.extractedBookingData
                                                .bookingDate)
                                            .toString(),
                                        style: TextStyle(fontSize: 25))
                                  ]),
                                  Divider(),
                                  Row(children: <Widget>[
                                    Text('Accommodation Name: '),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(acc
                                        .extractedBookingData.accommodationName
                                        .toUpperCase())
                                  ]),
                                  Divider(),
                                  Row(children: <Widget>[
                                    Text('Price: '),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text('\$' + acc.extractedBookingData.price)
                                  ]),
                                  Divider(),
                                  Row(children: <Widget>[
                                    Text('Student Number: '),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.04,
                                    ),
                                    Text(acc.extractedBookingData.studentNumber)
                                  ]),
                                  Divider(),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  _isloading
                                      ? CircularProgressIndicator()
                                      : RaisedButton.icon(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35.0)),
                                          color: Theme.of(context).accentColor,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Provider.of<AccomodationProvider>(
                                                    context,
                                                    listen: false)
                                                .delete(acc
                                                    .extractedBookingData.id);
                                          },
                                          icon: Icon(
                                            Icons.cancel,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          label: Text(
                                            'CANCEL ACCOMODATION',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                ]),
                              ));
                  }
                }
              }),
        ),
      ),
    );
  }
}
