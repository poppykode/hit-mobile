import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/events_provider.dart';
import '../models/config.dart';

class EventDetailsScreen extends StatelessWidget {
  static const String namedRoute = '/event-details-screen';
  @override
  Widget build(BuildContext context) {
    final eventId = ModalRoute.of(context).settings.arguments as int;
    final loadedEvent = Provider.of<EventsProvider>(context).findById(eventId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
        title: Text(Config.capitalize(loadedEvent.name),
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(60.0)),
                image: DecorationImage(
                    image: NetworkImage(loadedEvent.imageUrl),
                    fit: BoxFit.contain)),
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
