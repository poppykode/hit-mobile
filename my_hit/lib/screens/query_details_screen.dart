import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/query_provider.dart';
import '../models/HttpException.dart';
import '../models/config.dart';


class QueryDetailScreen extends StatefulWidget {
  static const String namedRoute = '/query-detail-screen';
  @override
  _QueryDetailScreenState createState() => _QueryDetailScreenState();
}

class _QueryDetailScreenState extends State<QueryDetailScreen> {
  var _message;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;


    Future<void> _saveForm(int qId) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Queryrovider>(context, listen: false).createResponse(qId, _message);
    } on HttpException catch (error) {
      print('from scren HttpException');
      print(error);
    } catch (error) {
      print('from screen catch');
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final queryId = ModalRoute.of(context).settings.arguments as int;
    final queryIns =   Provider.of<Queryrovider>(context, listen: false);
    final loadedQuery =
       queryIns.findById(queryId);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
        title: Text(Config.capitalize(loadedQuery.title), style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.only(left:5.0, right:5.0),
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: queryIns.getResponses(queryId),
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (dataSnapshot.error != null) {
                      return Center(
                        child: Text('something went wrong.'),
                      );
                    } else {
                      return Expanded(
                        child: Consumer<Queryrovider>(
                          child: Center(child: Text('No replies yet.')),
                          builder: (ctx, resp, ch) => resp.respItems.length <= 0
                              ? ch
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: resp.respItems.length,
                                  itemBuilder: (ctx, i) => Card(
                                        child: ListTile(
                                          title: Text(resp.respItems[i].fullName
                                              .toUpperCase()),
                                          subtitle: Text(
                                              resp.respItems[i].replyMessage),
                                          trailing: Text(DateFormat("hh:mm")
                                              .format(resp.items[i].date)),
                                        ),
                                      )),
                        ),
                      );
                    }
                  }
                }),
            Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: "Message",
                  prefixIcon: Icon(Icons.message),
                  suffixIcon: _isLoading? CircularProgressIndicator():
                      IconButton(icon: Icon(Icons.send), onPressed:(){
                        _saveForm(queryId);
                      }),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(35.0))),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Message can not be empty';
                  }
                },
                onSaved: (value) {
                  _message = value;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
