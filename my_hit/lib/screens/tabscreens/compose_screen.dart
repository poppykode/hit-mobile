import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/query_provider.dart';
import '../../models/HttpException.dart';

class ComposeScreen extends StatefulWidget {
  @override
  _ComposeScreenState createState() => _ComposeScreenState();
}

class _ComposeScreenState extends State<ComposeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _queryData = {'subject': '', 'message': ''};
  final _queryDescription = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _queryDescription.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Queryrovider>(context, listen: false)
          .createQuery(_queryData['subject'], _queryData['message']);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Message Successfully Send')));
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
    var deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_queryDescription);
                    },
                    decoration: InputDecoration(
                        labelText: 'Subject', border: OutlineInputBorder()),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Subject can not be empty';
                      }
                    },
                    onSaved: (value) {
                      _queryData['subject'] = value;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Message', border: OutlineInputBorder()),
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Message can not be empty';
                      }
                    },
                    onSaved: (value) {
                      _queryData['message'] = value;
                    },
                  ),
                  SizedBox(
                    height: deviceSize.height * 0.02,
                  ),
                  SizedBox(
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).primaryColor,
                            ),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35.0)),
                            color: Theme.of(context).accentColor,
                            onPressed: _saveForm,
                            label: Text(
                              'SEND MESSAGE',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
