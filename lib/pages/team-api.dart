import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'custom_widgets.dart';
import '/models/team.dart';
//right now

const tokens = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MGNkNzRmMmJmYWQ2MTNhODEwYTMzMDIiLCJpYXQiOjE2MzU2MDk4MzksImV4cCI6MTYzNzMzNzgzOX0._5K4sqsFhJbF58-skYaBwkqqANYITYCo6_EcxUTTWqY";

Future<bool> createTeam(String team_name, 
                         String team_description, 
                         bool team_visible, 
                         String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({'name' : team_name, 
  'description': team_description, 'visible': team_visible});
  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
      print("Successfully created teamSuccess");
    return true;
  }
  return null;
}


Future<Team> getUserTeam(String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/user/team";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  final response = await http.get(url, headers: headers);
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    Team team = new Team.fromJson(data);
    return team;
  }
  return null;
}

Future<Team> getTeamInfo(String teamId,
                         String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/team" + teamId;

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  final response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print(response.body);
    //Team team = new Team.fromJson(data);
    //print("Successfully created get team");
    //return team;
  }
  return null;
}
/*
Future<List<Team>> getTeams(String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/teams";

  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    List<String> teamStrings = List.from(jsonDecode(response.body));
    List<Team> teamsList = [];
    for(int i = 0; i < teamStrings.length; i++){
      teamsList[i] = Team.fromJson(teamStrings[i]);
    }
    print("Successfully retrieved all team Success");
    return teamsList;
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
  return null;
}
*/
Future<void> inviteTeamMember(String user_email, String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/invite";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({'email': user_email});
  //can we check if a user is already on a team by email???
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully invited");
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}

Future<void> leaveTeam(String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/team/leave";
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully left");
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}

Future<void> requestTeam(String team_id, String token) async {
  String url = "https://tartanhacks-backend.herokuapp.com/team/join/" + team_id;
  Map<String, String> headers = {"Content-type": "application/json", 
  "x-access-token": token};
  var body = json.encode({});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    print("Successfully request");
  }

  print(json.decode(response.body)['message'].toString() + "Unsuccessful");
}