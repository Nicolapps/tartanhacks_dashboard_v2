import 'dart:convert';

class Team {
  String teamId;
  List<String> members;
  String name;
  String event;
  String desc;
  String admin;
  bool visible;

  Team({this.teamId, this.visible, this.event, this.admin, this.members, this.desc,
  this.name});
  factory Team.fromJson(String jsonString) {
    Map<String, dynamic> body = json.decode(jsonString);
    return new Team(
        teamId:  body["_id"],
        visible: body["visible"],
        event: body["event"],
        admin: body["admin"],
        members: body["members"],
        desc: body["description"],
        name: body["name"]
    );
  }
}