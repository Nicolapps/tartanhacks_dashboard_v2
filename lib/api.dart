import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/profile.dart';
import 'models/event.dart';
import 'models/user.dart';

SharedPreferences prefs;

const baseUrl = "https://tartanhacks-backend.herokuapp.com/";

Future<User> checkCredentials(String email, String password) async {
  String url = baseUrl + "auth/login";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '","password":"' + password + '"}';

  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    User loginData;
    var data = json.decode(response.body);
    loginData = new User.fromJson(data);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', loginData.token);
    prefs.setString('email', loginData.email);
    prefs.setString('password', password);
    prefs.setBool('admin', loginData.admin);
    prefs.setString('id', loginData.id);

    return loginData;
  } else {
    print(json1);
    return null;
  }
}

Future<String> resetPassword(String email) async {
  String url = baseUrl + "auth/reset";
  Map<String, String> headers = {"Content-type": "application/json"};
  String json1 = '{"email":"' + email + '"}';
  final response = await http.post(url, headers: headers, body: json1);

  if (response.statusCode == 200) {
    return "Please check your email address to reset your password.";
  } else {
    return "We encountered an error while resetting your password. Please contact ScottyLabs for help";
  }
}

Future<Profile> getProfile(String id, String token) async {
  String url = baseUrl + "user/profile/" + id;
  Map<String, String> headers = {"Content-type": "application/json", "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Profile profile = new Profile.fromJson(data);
    return profile;
  } else {
    print(token);
    print(response.body.toString());
    return null;
  }
}

Future<List<Event>> getEvents() async {
  var url = baseUrl+'schedule/';
  final response = await http.get(url);
  print(response.statusCode);
  if (response.statusCode == 200){
    List<Event> EventsList;
    var data = json.decode(response.body) as List;
    EventsList = data.map<Event> ((json) => Event.fromJson(json)).toList();
    return EventsList;
  }else{
    return null;
  }
}

Future<bool> addEvents(String name, String description, int startTime, int endTime, double lat, double lng, String platform, String platformUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "events/new";
  Map<String, String> headers = {
    "Content-type": "application/json",
    "Token": token
  };


  String bodyJson = '{"name":"' + name +
      '","description":"' + description +
      '","startTime":' + startTime.toString() +
      ',"endTime":' + endTime.toString() +
      ',"lat":' + lat.toString() +
      ',"lng":' + lng.toString() +
      ',"platform":"' + platform +
      '"platformUrl":"' + platformUrl + '"}';

  print(bodyJson);
  final response = await http.post(url, headers: headers, body: bodyJson);
  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    return addEvents(
        name,
        description,
        startTime,
        endTime,
        lat,
        lng,
        platform,
        platformUrl);
  } else {
    return false;
  }
}

Future<bool> editEvents(String eventId, String name, String description, int startTime, int endTime, double lat, double lng, String platform, String platformUrl) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString("token");

  String url = baseUrl + "schedule/`${eventId}`";
  Map<String, String> headers = {"Content-type": "application/json", "Token": token};

  String bodyJson = '{"name":"' + name +
      '","description":"' + description +
      '","startTime":' + startTime.toString() +
      ',"endTime":' + endTime.toString() +
      ',"lat":' + lat.toString() +
      ',"lng":' + lng.toString() +
      ',"platform":"' + platform +
      '"platformUrl":"' + platformUrl + '"}';

  print(bodyJson);

  final response = await http.patch(url, headers: headers, body: bodyJson);
  if (response.statusCode == 200) {
    return true;
  }else if(response.statusCode == 401){
    return editEvents(
        eventId,
        name,
        description,
        startTime,
        endTime,
        lat,
        lng,
        platform,
        platformUrl);
  }else{
    return false;
  }
}
