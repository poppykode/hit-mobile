import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_hit/models/HttpException.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/config.dart';
import '../models/canteen.dart';

class CanteenProvider with ChangeNotifier {
  Canteen _extractedCanteenData;

  Canteen get extractedCanteenData {
    return _extractedCanteenData;
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('UserData')) as Map<String, Object>;
    return extractedData['_token'];
  }

  Future<void> createMeal(String numberOfMeals) async {
    var _token = await getToken();

    const url = Config.base_url + 'canteen/create';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'number_of_meals': int.parse(numberOfMeals),
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers);
      final resp = json.decode(response.body);
      print(resp);
      if (resp['error'] != null) {
        print('from provider HttpException');
        print(resp['error']);
        throw HttpException(resp['error']);
      }
      notifyListeners();
    } catch (error) {
      print('from provider catch');
      print(error);
    }
  }

  Future<void> getSummary() async {
    var _token = await getToken();
    String url = Config.base_url + 'canteen/get-summary';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      print('data racho');
      print(extractedData);

      Canteen canteen = Canteen(
        id: extractedData[0]['id'],
        numberOfMeals: extractedData[0]['number_of_meals'].toString(),
        date: DateTime.parse(extractedData[0]['timestamp']),
        totalCost: extractedData[0]['total_cost'].toString(),
        paid: extractedData[0]['paid'],
      );

      print('loadedData');

      _extractedCanteenData = canteen;
      notifyListeners();
    } catch (error) {
      print('pano pa catch exception');
      print(error);
    }
  }

  Future<void> makePayment(int amount) async {
    var _token = await getToken();

    const url = Config.base_url + 'canteen/make-payment';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'amt_paid': amount,
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers);
      final resp = json.decode(response.body);
      print(resp);
      if (resp['error'] != null) {
        print('from provider HttpException');
        print(resp['error']);
        throw HttpException(resp['error']);
      }
      notifyListeners();
    } catch (error) {
      print('from provider catch');
      print(error);
      throw error;
    }
  }

  Future<void> buyMeal(int numberOfMeals) async {
    var _token = await getToken();

    const url = Config.base_url + 'canteen/buy-meal';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'number_of_meals': numberOfMeals,
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers);
      final resp = json.decode(response.body);
      print(resp);
      if (resp['error'] != null) {
        print('from provider HttpException');
        print(resp['error']);
        throw HttpException(resp['error']);
      }
      notifyListeners();
    } catch (error) {
      print('from provider catch');
      print(error);
      throw error;
    }
  }

  Future<bool> hasMeal() async {
    var _token = await getToken();
    bool resBool;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var url = Config.base_url + 'canteen/check-meal';
    try {
      final response = await http.get(url, headers: headers);
      print(response);
      final resp = json.decode(response.body);
      resBool = resp['has_meal'] as bool;
    } catch (error) {
      print(error);
    }
    notifyListeners();
    return resBool;
  }
}
