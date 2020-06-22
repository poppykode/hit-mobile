import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/HttpException.dart';
import '../providers/canteen_provider.dart';
import '../screens/canteen_make_payment.dart';

class CanteenPurchaseScreen extends StatefulWidget {
  static const String namedRoute = '/canteen-purchase-screen';

  @override
  _CanteenPurchaseScreenState createState() => _CanteenPurchaseScreenState();
}

class _CanteenPurchaseScreenState extends State<CanteenPurchaseScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  String numberOfMeals = '';

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
          .createMeal(numberOfMeals);
      Navigator.of(context)
          .popAndPushNamed(CanteenMakePaymentScreen.namedRoute);
    } on HttpException catch (error) {
      print('from screen HttpException');
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
        title:
            Text('Select Number Meals', style: TextStyle(color: Colors.white)),
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
                            labelText: 'Number of Meals',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Number of Meals can not be empty';
                          }
                        },
                        onSaved: (value) {
                          numberOfMeals = value;
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
                                  'Add Meals',
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
