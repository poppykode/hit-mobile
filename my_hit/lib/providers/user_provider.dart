import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/HttpException.dart';
import '../models/user.dart';
import '../models/config.dart';

class UserProvider with ChangeNotifier {
  String token;
  User _extractedUserWacho;


  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('UserData')) as Map<String, Object>;
    return extractedData['_token'];
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('UserData')) as Map<String, Object>;
    return extractedData['_userId'];
  }

  User get userWacho {
    if (_extractedUserWacho == null) {
      print('user haana chinhu');
      return null;
    }
    return _extractedUserWacho;
  }

  Future<User> getUser() async {
    var _token = await getToken();
    var _userId = await getUserId();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };

    try {
      var url = Config.base_url +'accounts/user?id=$_userId';
      final response = await http.get(url, headers: headers);

      final extractedData = json.decode(response.body);

      if (extractedData == null) {
        throw HttpException(
            'your user information does not exist, please contact admin.');
      }
      User extractedUserData = User(
          username: extractedData[0]['username'],
          firstName: extractedData[0]['first_name'],
          lastName: extractedData[0]['last_name'],
          email: extractedData[0]['email'],
          imageUrl: extractedData[0]['image_url'],
          studentNumber: extractedData[0]['student_number']);
      _extractedUserWacho = extractedUserData;
      notifyListeners();
      return _extractedUserWacho;
    } catch (error) {
      throw error;
    }
  }
}
