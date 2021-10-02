import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//right now
Future<bool> createTeam(String team_name) async {
  const url = "https://tartanhacks-backend.herokuapp.com/teams/";
  String json1 = '{"name":"' + team_name + '"}';
  final response = await http.post(url, body: json1);

  if (response.statusCode == 200) {
      showDialog("Successfully created team", "Success");
    return true;
  }
  return null;
}

//ideally
Future<bool> createTeam2(String creator_name, String team_name, 
                         String team_description, String team_id, String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/teams/";

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  var body = json.encode({'creator_name' : creator_name, 
  'team_name' : team_name, 'desc' : team_description, 'team_id': team_id});
  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
      showDialog("Successfully created team", "Success");
    return true;
  }
  return null;
}

Future<bool> inviteTeamMember(String team_id, String user_id, String token) async {
  const url = "https://tartanhacks-backend.herokuapp.com/teams/invite/" + user_id;

  Map<String, String> headers = {"Content-type": "application/json", "Token": token};
  var body = json.encode({'team_id' : team_id, 'user_id' : user_id});
  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
      showDialog("Successfully invited member", "Success");
    return true;
  }
  return null;
}

/*
list of modules to interact with 
- request team
- request user
- request accept
- request decline
- request cancel
- invite a team member
    - need something to say you've reached member limit
- leave a team
- create a team

NEEDED:
- fields: team ids, team descriptions, tokens???
- moduels: get list of team members, edit team description

QUESTIONS/TO DO:
- how do you actually connect to the api
- brainstorm more fields and modules that we need
- how to connect buttons to the output
- how to display error messages
*/