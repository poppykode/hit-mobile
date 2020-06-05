import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timetable.dart';
import '../models/config.dart';

class Timetable with ChangeNotifier {
  List<Course> _items;
  PDFDocument _timetablePDF;

  List<Course> get items {
    print('items has run');
    return [..._items];
  }

  PDFDocument get timetablePDF{
    return _timetablePDF;
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

  Future<void> getCourses() async {
    const String url = Config.base_url + 'course/courses';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      if (extractedData == null) {
        return;
      }
      final List<Course> loadedData = [];
      extractedData.forEach((courseData) {
        loadedData.add(
            Course(id: courseData['id'].toString(), name: courseData['name']));
        print(courseData['name'] + ' ' + courseData['id'].toString());
      });
      print('data');
      print(loadedData);
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print('pano pa catch exception');
      print(error);
    }
  }

  Future<void> getFileFromUrl() async {
    var _token = await getToken();
    var _couserId = await getCourseId();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Token $_token'
    };
    try {
      var url = Config.base_url + 'course/timetable/$_couserId';
      final response = await http.get(url, headers: headers);
      print('response pano');

      final data = json.decode(response.body);
      final pdfUrl = data[0]['file_url'];
      var pdfResult = await PDFDocument.fromURL(pdfUrl);
      _timetablePDF = pdfResult;
    } catch (error) {
      print(error);
    }
  }

  Future<File> _downloadFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
}
}
