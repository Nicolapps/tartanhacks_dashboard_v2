import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import '../api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'team-api.dart';
import '/models/team.dart';

class ViewTeam extends StatefulWidget {
  @override
  _ViewTeamState createState() => _ViewTeamState();
}

class _ViewTeamState extends State<ViewTeam> {
  SharedPreferences prefs;
  String id;

  List<Map> _teamMembers = [
    {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
    {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"},
    {'name': "Joyce Hong", 'email': "joyceh@andrew.cmu.edu"}
    ];
  String _teamName = "My Team";
  String _teamDesc = "Team Description";
  int numMembers = 3;
  bool isMember = true;
  String teamId;
  String token;

  Team team;
  bool read = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  Widget mailIconSelect(bool read){
    if (read){
      return Icon(
          Icons.email,
          color: Theme.of(context).colorScheme.secondary,
          size: 40.0
      );
    } else {
      return Icon(
          Icons.mark_email_unread,
          color: Theme.of(context).colorScheme.secondary,
          size: 40.0
      );
    }
  }

  void leaveJoin(isMember) async {
    if (isMember){
      leaveTeam(token);
    } else {
      requestTeam(team.teamId, token);
    }
  }

  void getData() async{
    //checkCredentials('test@example.com', 'string'); 
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id');
    token = prefs.getString('token');
    teamId = await getUserTeam(token);
    team = await getTeamInfo(teamId, token);
    _teamMembers = team.members;
    _teamDesc = team.desc;
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  Widget _buildTeamHeader(bool read) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("TEAM", style: Theme.of(context).textTheme.headline2),
        mailIconSelect(read)
      ]
    );
  }

  Widget _buildTeamDesc() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_teamName, style: Theme.of(context).textTheme.headline4),
          Text(_teamDesc, style: Theme.of(context).textTheme.bodyText2)
        ]
    );
  }

  Widget _buildMember(int member) {
    String email_str = "(" + _teamMembers[member]['email'] + ")";
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_teamMembers[member]['name'], style: Theme.of(context).textTheme.bodyText2),
          Text(email_str, style: Theme.of(context).textTheme.bodyText2)
        ]
    );
  }

  Widget _buildTeamMembers(int numMembers) {
    List<Widget> teamMembers = <Widget>[];
    for(int i = 0; i < numMembers; i++){
      teamMembers.add(_buildMember(i));
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Team Members", style: Theme.of(context).textTheme.headline4),
          Column(
              children: teamMembers
          )
        ]
    );
  }

  Widget _leaveJoinTeamBtn(bool isMember) {
    String buttonText = "Leave Team";
    if(!isMember){
      buttonText = "Join Team";
    }
    return (
        SolidButton(
          text: "Leave Team",
        ),
  }

  List<Widget> _infoList(bool isMember){
    List<Widget> info = <Widget>[];
    info.add(
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            //height: screenHeight*0.05,
            child: _buildTeamHeader()
        )
    );
    info.add(
        Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //height: screenHeight*0.2,
            child: _buildTeamDesc()
        )
    );
    info.add(
        Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            //height: screenHeight*0.1,
            child: _buildTeamMembers(numMembers)
        )
    );
    info.add(_leaveJoinTeamBtn(isMember));
    return info;
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body:  Container(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight
              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TopBar(backflag: true),
                    Stack(
                      children: [
                        Column(
                            children:[
                              SizedBox(height:screenHeight * 0.05),
                              CustomPaint(
                                  size: Size(screenWidth, screenHeight * 0.75),
                                  painter: CurvedTop(
                                      color1: Theme.of(context).colorScheme.secondaryVariant,
                                      color2: Theme.of(context).colorScheme.primary,
                                      reverse: true)
                              ),
                            ]
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: GradBox(
                              width: screenWidth*0.9,
                              height: screenHeight*0.75,
                              padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      //height: screenHeight*0.05,
                                      child: _buildTeamHeader(read)
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      //height: screenHeight*0.2,
                                      child: _buildTeamDesc()
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      //height: screenHeight*0.05,
                                      child: SolidButton(
                                          text: "EDIT TEAM NAME AND INFO"
                                      )
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      //height: screenHeight*0.1,
                                      child: _buildTeamMembers()
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      //height: screenHeight*0.1,
                                      child: SolidButton(
                                          text: "INVITE NEW MEMBER"
                                      )
                                    ),
                                    _leaveTeamBtn()
                                ]
                              )
                            )
                        )
                      ],
                    )
                  ],
                )
            )
          )
        )
    );
  }
}