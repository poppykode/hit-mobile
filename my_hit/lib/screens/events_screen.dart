import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../screens/event_details_screen.dart';
import '../providers/events_provider.dart';
import '../models/config.dart';

class EventsScreen extends StatelessWidget {
  static const String namedRoute = '/events-screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notices',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder(
        future: Provider.of<EventsProvider>(context, listen: false).getEvents(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(child: Text('An error occured'));
            } else {
              return Consumer<EventsProvider>(
                child: Center(child: Text('No notices found.')),
                builder: (ctx, events, ch) => events.items.length <= 0
                    ? ch
                    : ListView.builder(
                        itemCount: events.items.length,
                        itemBuilder: (ctx, i) => InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  EventDetailsScreen.namedRoute,
                                  arguments: events.items[i].id),
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(DateFormat("hh:mm")
                                        .format(events.items[i].date)
                                        .toString()),
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                  ),
                                  title:
                                      Text(events.items[i].name.toUpperCase()),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(Icons.location_on),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      Text(Config.capitalize(
                                          events.items[i].location))
                                    ],
                                  ),
                                  trailing: Text(DateFormat("yMMMd")
                                      .format(events.items[i].date)
                                      .toString()),
                                ),
                              ),
                            )),
              );
            }
          }
        },
      ),
    );
  }
}
