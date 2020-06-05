import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/HttpException.dart';
import '../models/config.dart';

class Auth with ChangeNotifier {
  String _token;
  int _userId;
  int _courseId;
  bool _hasAccomodation;

  bool get auth {
    print('auth yarunner');
    return token != null;
  }

  bool get hasAccomodation {
    return _hasAccomodation;
  }


  String get token {
    if (_token != null) {
      print('get token');
      print(_token);
      return _token;
    }
    return null;
  }

  Future<void> login(String username, String password) async {
    const String url = Config.base_url + 'accounts/login';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    var body = {'username': username, 'password': password};
    try {
      final response =
          await http.post(url, body: json.encode(body), headers: headers);
      final resp = json.decode(response.body);
      _userId = resp["user_id"];
      _token = resp['token'];
      _courseId = resp['course_id'];
      _hasAccomodation = resp['has_accomodation'];
      if (resp['error'] != null) {
        throw HttpException(resp['error']);
      }
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
          {'_token': _token, '_userId': _userId, '_courseId': _courseId,});
      prefs.setString('UserData', userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  
  Future<void> signin(File image,String username, String firstName, String lastname,
      String email,String courseId, String password) async{
                       
    const String url =  Config.base_url +'accounts/register';

     try{
       final _filename =  basename(image.path);
      Map<String, String> headers = {
       'Content-Type':'application/x-www-form-urlencoded',
       'Content-Disposition':'attachment; filename=$_filename'
       
       };
       final stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
        final request = http.MultipartRequest('POST',Uri.parse(url));
        final length = await image.length();
        request.headers.addAll(headers);
        request.fields['username'] = username;
        request.fields['first_name'] = firstName;
        request.fields['last_name'] =lastname;
        request.fields['course'] = courseId.toString();
        request.fields['email'] =email;
        request.fields['password'] =password;
        
        final _image =  http.MultipartFile('image',stream,length,filename:_filename);
        request.files.add(_image);
        final response = await request.send();
        print(response);
        response.stream.transform(utf8.decoder).listen((value){
        print(value);
        });
          notifyListeners();
        if(response.statusCode == 200){
          print('successfully uploaded');
        }
  
     }catch (error){
       print(error);
       throw error;
     }
  
  }

 

Future<void> logout()async{
  const url =  Config.base_url + 'accounts/logout';
  try{
     Map<String, String> headers = {'Authorization': 'Token $token'};
    print('header');
    print(headers);
  final response =  await http.get(url,headers: headers);
  final resp = json.decode( response.body);
  print('logout yacho');
  print(resp);
  _token =null;
  _userId = null;
  _courseId=null;
  final prefs = await SharedPreferences.getInstance();
  prefs.remove('UserData');
  notifyListeners();
    if (resp['error'] != null) {
        // throw HttpException(resp['error']);
        print(resp['error']);
      }
  }catch (error){
    print(error);
    throw error;
  }

}

Future<bool> tryAutologin() async{
  final prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('UserData')){
    return false;
  }
  final extractedData = json.decode(prefs.getString('UserData')) as Map<String,Object>;
  _token =extractedData['_token'];
  _userId = extractedData['_userId'];
  _courseId=extractedData['_courseId'];
    notifyListeners();
  return true;
}


}
