import 'package:flutter/material.dart';
import 'package:my_hit/models/HttpException.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/accommodation.dart';
import '../models/config.dart';

class AccomodationProvider with ChangeNotifier {
  Booking _extractedBookingData;
  List<Accomodation> _itemsAccommodation;

  Booking get extractedBookingData {
    // if (_extractedBookingData == null) {
    //   print('acc haana chinhu');
    //   return null;
    // }
    return _extractedBookingData;
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

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('UserData')) as Map<String, Object>;
    return extractedData['_userId'];
  }

  Future<int> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('UserData')) as Map<String, Object>;
    return extractedData['_userId'];
  }

  List<Accomodation> get itemsAccommodation {
    return [..._itemsAccommodation];
  }

  Future<void> getAcommodation() async {
    var _token = await getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    const String url = Config.base_url + 'accomodation/get_all_accommodation';
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<Accomodation> loadedData = [];
      extractedData.forEach((accommoData) {
        loadedData.add(Accomodation(
          id: accommoData['id'],
          name: accommoData['name'],
          price: accommoData['price'],
          availableSpaces: accommoData['available_spaces'],
        ));
      });
      _itemsAccommodation = loadedData;
      notifyListeners();
    } catch (error) {
      print('catch error');
      print(error);
    }
  }

  Future<void> createBooking(int accId) async {
    var _token = await getToken();
    var _userId = await getUser();
    const url = Config.base_url + 'accomodation/book';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'user': _userId,
      'accomodation': accId,
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers);
      final resp = json.decode(response.body);
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

  Future<void> delete(int id) async {
    var _token = await getToken();
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Token $_token',
    };
    var url = Config.base_url + 'accomodation/get_accomodation_detail/$id';
    try {
      print(url);
      await http.delete(url, headers: headers);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> getABooking() async {
    var _token = await getToken();
    var _userId = await getUserId();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };

    try {
      var url = Config.base_url +
          'accomodation/get_booking_by_user_id?user_id=$_userId';
      print(url);
      final response = await http.get(url, headers: headers);
      if (response == null) {
        print('hamuna chinhu.');
        return;
      }
      print('response yacho');
      print(response);
      final extractedData = json.decode(response.body);
      print('booking yacho,');
      print(extractedData);
      Booking extractedBookingData = Booking(
        id: extractedData[0]['id'],
        accomodation: extractedData[0]['accomodation'],
        accommodationName: extractedData[0]['accomodation_name'],
        studentNumber: extractedData[0]['student_number'],
        bookingDate: DateTime.parse(extractedData[0]['timestamp']),
        price: extractedData[0]['price'],
      );
      _extractedBookingData = extractedBookingData;
      notifyListeners();
    } catch (error) {
      print(error.toString());

      throw error;
    }
  }

  Future<bool> hasAccomodation() async {
    var _userId = await getUser();
    var _token = await getToken();
    bool resBool;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var url = Config.base_url + 'accomodation/has_booking/$_userId';
    try {
      final response = await http.get(url, headers: headers);
      print(response);
      final resp = json.decode(response.body);
      resBool = resp['has_accomodation'] as bool;
    } catch (error) {
      print(error);
    }
    notifyListeners();
    return resBool;
  }
}
