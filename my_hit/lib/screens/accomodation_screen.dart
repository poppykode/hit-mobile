import 'package:flutter/material.dart';
import 'package:my_hit/models/accommodation.dart';
import 'package:provider/provider.dart';
import '../providers/accomodation_provider.dart';
import '../models/HttpException.dart';
import '../screens/accommodation_summary_screen.dart';

class AccomodationScreen extends StatefulWidget {
  static const String namedRoute = '/accomodation-screen';
  @override
  _AccomodationScreenState createState() => _AccomodationScreenState();
}

class _AccomodationScreenState extends State<AccomodationScreen> {
  var _selectedAccomodation;
  bool _isLoading = false;

  List<Widget> _createRadioListAccomodation() {
    List<Widget> widgets = [];
    var acc = Provider.of<AccomodationProvider>(context, listen: false)
        .itemsAccommodation;
    for (Accomodation a in acc) {
      widgets.add(RadioListTile(
        value: a.id,
        groupValue: _selectedAccomodation,
        title: Text(a.name.toUpperCase()),
        subtitle:
            Text('Available Spaces ' + ' ' + a.availableSpaces.toString()),
        onChanged: (val) {
          setState(() {
            _selectedAccomodation = val;
            print(val);
          });
        },
        selected: _selectedAccomodation == a.id,
        activeColor: Theme.of(context).primaryColor,
      ));
    }

    return widgets;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Message!'),
        content: Text(message),
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

  Future<void> _saveForm() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AccomodationProvider>(context, listen: false)
          .createBooking(_selectedAccomodation);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Booking Successfully done.')));
      Navigator.of(context).pushNamed(AccommodationSummaryScreen.namedRoute);
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {}
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Accomodation Booking',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              alignment: Alignment.center,
              child: Text(
                'All Available Accomodation.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              )),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          SingleChildScrollView(
              child: Column(children: <Widget>[
            FutureBuilder(
                future:
                    Provider.of<AccomodationProvider>(context, listen: false)
                        .getAcommodation(),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      return Center(child: Text('Something went wrong'));
                    } else {
                      return Column(children: _createRadioListAccomodation());
                    }
                  }
                })
          ])),
          _selectedAccomodation != null
              ? _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton.icon(
                      icon: Icon(
                        Icons.sentiment_satisfied,
                        color: Theme.of(context).primaryColor,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35.0)),
                      color: Theme.of(context).accentColor,
                      onPressed: _saveForm,
                      label: Text(
                        'MAKE A BOOKING',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
              : RaisedButton.icon(
                  icon: Icon(
                    Icons.sentiment_dissatisfied,
                    color: Theme.of(context).accentColor,
                  ),
                  disabledElevation: 0.0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35.0)),
                  color: Colors.grey,
                  onPressed: null,
                  label: Text(
                    'MAKE A BOOKING',
                    style: TextStyle(color: Colors.white),
                  ),
                )
        ]),
      ),
    );
  }
}
