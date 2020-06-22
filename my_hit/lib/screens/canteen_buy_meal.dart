import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/HttpException.dart';
import '../providers/canteen_provider.dart';
import '../screens/canteen_summary_screen.dart';

class CanteenBuyMealScreen extends StatefulWidget {
  static const String namedRoute = '/canteen-buy-meal-screen';

  @override
  _CanteenBuyMealScreenState createState() => _CanteenBuyMealScreenState();
}

class _CanteenBuyMealScreenState extends State<CanteenBuyMealScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  String meals = '';
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
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
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CanteenProvider>(context, listen: false)
          .buyMeal(int.parse(meals));
      Navigator.of(context).popAndPushNamed(CanteenSummaryScreen.namedRoute);
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Meal/s successfully bought.')));
    } on HttpException catch (error) {
      print('from screen HttpException');
      _showErrorDialog(error.toString());
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0.0,
        title: Text('Buy a Meal', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Number of Meal/s',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Number of meal can not be empty';
                          }
                        },
                        onSaved: (value) {
                          meals = value;
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
                                  Icons.fastfood,
                                  color: Theme.of(context).primaryColor,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0)),
                                color: Theme.of(context).accentColor,
                                onPressed: _saveForm,
                                label: Text(
                                  'Buy Meals',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
