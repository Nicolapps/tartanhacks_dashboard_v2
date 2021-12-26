import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Team {
  final String teamID;
  final bool visible;
  final dynamic admin;
  final String name;
  final List<dynamic> members;
  final String description;
<<<<<<< Updated upstream
=======
  
>>>>>>> Stashed changes

  Team({
    this.teamID, 
    this.visible, 
    this.admin, 
    this.name, 
    this.members, 
    this.description});

  factory Team.fromJson(Map<String, dynamic> parsedJson) {
    return new Team(
        teamID:  parsedJson["_id"],
        visible: parsedJson["visible"],
        admin: parsedJson["admin"],
        name: parsedJson["name"],
        members: parsedJson["members"],
        description: parsedJson["description"]
    );
  }
}
