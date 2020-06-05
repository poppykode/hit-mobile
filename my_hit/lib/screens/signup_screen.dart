import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../widgets/input_image.dart';
import '../providers/timetable_provider.dart';
import '../models/HttpException.dart';

class SignUpScreen extends StatefulWidget {
  static const String namedRoute = '/sign-up-screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var couse;
  final _passwordController = TextEditingController();
  final _usernamePassword = FocusNode();
  final _firstName = FocusNode();
  final _lastName = FocusNode();
  final _email = FocusNode();
  final _confirmPassword = FocusNode();
  // final _courses = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  File _pickedImage;

  void _selectedImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  Map<String, String> _authData = {
    'username': '',
    'first_name': '',
    'last_name': '',
    'email': '',
    'password': ''
  };
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
      await Provider.of<Auth>(context, listen: false).signin(
          _pickedImage,
          _authData['username'],
          _authData['first_name'],
          _authData['last_name'],
          _authData['email'],
          couse,
          _authData['password']);

      Navigator.of(context).pop();
    } on HttpException catch (error) {
      var errorMessage = 'Signup failed.';
      if (error.toString().contains('username already exists.')) {
        errorMessage = 'username already exists';
      } else if (error.toString().contains('email already exists.')) {
        errorMessage = 'email already exists';
      } else if (error.toString().contains('Accommodation in ')) {
        errorMessage = error.toString();
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Something went wrong';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernamePassword.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _confirmPassword.dispose();
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
                                FocusScope.of(context).requestFocus(_firstName);
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
                            ImageInput(_selectedImage),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_lastName);
                              },
                              decoration: InputDecoration(
                                  labelText: 'First Name',
                                  border: OutlineInputBorder()),
                              focusNode: _firstName,
                              onEditingComplete: _firstName.unfocus,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'First name can not be empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['first_name'] = value;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) {
                                FocusScope.of(context).requestFocus(_email);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder()),
                              focusNode: _lastName,
                              onEditingComplete: _lastName.unfocus,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Last name can not be empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['last_name'] = value;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            FutureBuilder(
                              future:
                                  Provider.of<Timetable>(context, listen: false)
                                      .getCourses(),
                              builder: (ctx, dataSnapShot) {
                                if (dataSnapShot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (dataSnapShot.error != null) {
                                    return Center(
                                      child: Text('An error occurred!'),
                                    );
                                  } else {
                                    return Consumer<Timetable>(
                                      child: Text(
                                        'No things added yet.',
                                        style: TextStyle(fontSize: 15.0),
                                        textAlign: TextAlign.center,
                                      ),
                                      builder: (ctx, courseData, ch) =>
                                          courseData.items.length <= 0
                                              ? ch
                                              : DropdownButtonFormField(
                                                  decoration: InputDecoration(
                                                      border:
                                                          OutlineInputBorder()),

                                                  // focusNode: _courses,
                                                  items: courseData.items
                                                      .map((value) =>
                                                          DropdownMenuItem(
                                                            child: Text(
                                                              value.name,
                                                            ),
                                                            value: value.id,
                                                          ))
                                                      .toList(),
                                                  onChanged:
                                                      (selectedCourseValue) {
                                                    setState(() {
                                                      couse =
                                                          selectedCourseValue;
                                                    });
                                                  },
                                                  value: couse,
                                                  isExpanded: true,
                                                  hint: Text(
                                                    'Select A Course.',
                                                  ),
                                                ),
                                    );
                                  }
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_usernamePassword);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder()),
                              keyboardType: TextInputType.emailAddress,
                              focusNode: _email,
                              onEditingComplete: _email.unfocus,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Email can not be empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['email'] = value;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_confirmPassword);
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder()),
                              controller: _passwordController,
                              focusNode: _usernamePassword,
                              onEditingComplete: _usernamePassword.unfocus,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Password can not be empty';
                                }
                              },
                              onSaved: (value) {
                                _authData['password'] = value;
                              },
                            ),
                            SizedBox(
                              height: deviceSize.size.height * 0.02,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  border: OutlineInputBorder()),
                              obscureText: true,
                              focusNode: _confirmPassword,
                              onEditingComplete: _confirmPassword.unfocus,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                              },

                              // onFieldSubmitted: (_) {
                              //   _saveForm();
                              // },
                            ),
                            SizedBox(
                              height: deviceSize.size.height * 0.02,
                            ),
                            SizedBox(
                              child: _isLoading
                                  ? CircularProgressIndicator()
                                  : RaisedButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(35.0)),
                                      color: Theme.of(context).accentColor,
                                      onPressed: () => _saveForm(),
                                      child: Text(
                                        'REGISTER',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            FlatButton(
                              
                              child: Text(
                                'LOGIN INSTEAD',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
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
