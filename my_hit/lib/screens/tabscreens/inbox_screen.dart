import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/query_provider.dart';
import '../../screens/query_details_screen.dart';


class InboxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Queryrovider>(context,listen: false).getQueries(),
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return  Center(child: CircularProgressIndicator());
        } else {
          if (dataSnapshot.error != null) {
            return Center(
              child: Text('An error occurred!'),
            );
          } else {
            return Consumer<Queryrovider>(
              child: Center(
                child: Text(
                  'No messages.',
                  style: TextStyle(fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
              ),
              builder: (ctx, query, ch) => query.items.length <= 0
                  ? ch
                  : ListView.builder(
                    itemCount:query.items.length ,
                    itemBuilder: (ctx,i)=>Card(
                      margin: EdgeInsets.only(left:15,right: 15,top:10),
                                          child: Container(
                                            color:query.items[i].userid == 9? Color(0xffEFF0F1): Colors.white,
                                            child: ListTile(
                        leading:CircleAvatar(backgroundImage:NetworkImage(query.items[i].imageUrl)),
                        title: Text(query.items[i].title.toUpperCase() +'('+ DateFormat("yMMMd").format( query.items[i].date)+')'),
                        subtitle: Text(query.items[i].description,overflow: TextOverflow.fade,maxLines: 1,),
                        trailing: IconButton(icon: Icon(Icons.reply), onPressed: () {
                          Navigator.of(context).pushNamed(QueryDetailScreen.namedRoute,arguments:query.items[i].id);
                        },),

                      ),
                                          ),
                    )),
            );
          }
        }
      },
    );
  }
}
