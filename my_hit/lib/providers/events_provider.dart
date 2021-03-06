import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../models/config.dart';

class EventsProvider with ChangeNotifier {
  List<Event> _items;

  List<Event> get items {
    return [..._items];
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

  Event findById(int id) {
    return _items.firstWhere((event) => event.id == id);
  }

  Future<void> getEvents() async {
    var _token = await getToken();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    const String url = Config.base_url + 'events/all';
    try {
      final response = await http.get(url, headers: headers);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<Event> loadedData = [];
      print('events data');
      print(extractedData);
      extractedData.forEach((eventData) {
        loadedData.add(Event(
            id: eventData['id'],
            name: eventData['name'],
            descrption: eventData['description'],
            date: DateTime.parse(eventData['date']),
            location: eventData['location'],
            imageUrl: eventData['image_url']));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print('catch error');
      print(error);
    }
  }

  Future<void> createFCMToken(String fcmToken) async {
    var _token = await getToken();
    var _userId = await getUserId();

    const url = Config.base_url + 'fcm/create';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'user': _userId,
      'fcm_token': fcmToken,
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers);
      final resp = json.decode(response.body);
      print(resp);
      notifyListeners();
    } catch (error) {
      print('from provider catch');
      print(error);
    }
  }
}
