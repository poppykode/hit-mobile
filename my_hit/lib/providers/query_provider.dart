import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/HttpException.dart';
import '../models/query.dart';
import '../models/config.dart';

class Queryrovider with ChangeNotifier {
  List<Query> _items;
  List<Response> _respItems;

  List<Query> get items {
    return [..._items];
  }
    List<Response> get respItems {
    return [..._respItems];
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

  Future<int> getCourseId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('UserData')) {
      return null;
    }
    final extractedData =
        json.decode(prefs.getString('UserData')) as Map<String, Object>;
    return extractedData['_courseId'];
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

 Query findById(int id) {
    return _items.firstWhere((query) => query.id == id);
  }

  Future<void> createQuery(String title, String description) async {
    var _token = await getToken();
    var _userId = await getUserId();
    var _courseId = await getCourseId();
    const url =Config.base_url + 'query/create';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'department': _courseId,
      'student': _userId,
      'title': title,
      'query_description': description,
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers) ;
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

  Future<void> createResponse(int queryId,String message) async {
    var _token = await getToken();
    var _userId = await getUserId();
    const url =Config.base_url + 'query/response';
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    var body = {
      'query': queryId,
      'commentator': _userId,
      'reply_message': message,
    };

    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers) ;
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

  Future<void> getQueries() async {
    var _token = await getToken();
    const String url =Config.base_url + 'query/all';
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
      final List<Query> loadedData = [];
      extractedData.forEach((queryData) {
        loadedData.add(Query(
          id: queryData['id'],
          departmentId: queryData['department'],
          userid: queryData['student'],
          title: queryData['title'],
          description: queryData['query_description'],
          date:DateTime.parse(queryData['timestamp']) ,
          createdBy: queryData['fullname'],
          imageUrl: queryData['image_url']
    
        ));
      });
        print('loadedData');
      print(loadedData);

      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print('pano pa catch exception');
      print(error);
    }
  }

    Future<void> getResponses(int id) async {
    var _token = await getToken();
     String url =Config.base_url + 'query/response/$id';
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
      final List<Response> loadedData = [];
      extractedData.forEach((respData) {
        loadedData.add(Response(
          id: respData['id'],
          query: respData['query'],
          commentator: respData['commentator'],
          replyMessage:  respData['reply_message'],
          fullName:  respData['fullname'],
        ));
      });
        print('loadedData');
      print(loadedData.length);

      _respItems = loadedData;
      notifyListeners();
    } catch (error) {
      print('pano pa catch exception');
      print(error);
    }
  }
}
