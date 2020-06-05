import 'package:flutter/material.dart';
import './signup_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../models/HttpException.dart';

class LoginScreen extends StatefulWidget {
  static const String namedRoute = '/login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userPassword = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  Map<String, String> _authData = {'username': '', 'password': ''};
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

  @override
  void dispose() {
    super.dispose();
    _userPassword.dispose();
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
      await Provider.of<Auth>(context, listen: false)
          .login(_authData['username'], _authData['password']);
    } on HttpException catch (error) {
      var errorMessage = 'Login failed.';
      if (error.toString() != null) {
        errorMessage = error.toString();
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Login failed something went wrong.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/hitbg.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                    Colors.black.withOpacity(0.7),
                    Color(0xffFFB400).withOpacity(0.8)
                  ])),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, top: 20, bottom: 20),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_userPassword);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Username',
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Username can not be empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['username'] = value;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder()),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password can not be empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                               onFieldSubmitted: (_){
                                      _saveForm();
                                    },
                            ),
                            SizedBox(
                              height: deviceSize.size.height * 0.02,
                            ),
                            _isLoading? CircularProgressIndicator() :
                            SizedBox(
                              child: RaisedButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(35.0)),
                                color: Theme.of(context).accentColor,
                                onPressed: _saveForm,
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            FlatButton(
                             
                              child: Text(
                                'REGISTER INSTEAD',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(SignUpScreen.namedRoute),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
