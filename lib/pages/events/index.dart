import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../custom_widgets.dart';
import 'package:share/share.dart';

class EventsHomeScreen extends StatefulWidget {
  @override
  _EventsHomeScreenState createState() => new _EventsHomeScreenState();
}

class _EventsHomeScreenState extends State<EventsHomeScreen> {
  SharedPreferences prefs;

  bool isAdmin = false;
  List eventData = [1,2,3,4,5];
  bool isSwitched = false;
  int selectedIndex = 1;




  @override
  initState() {
    super.initState();
    //getData();
  }

  Widget eventName(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: RichText(
            text: TextSpan(
              text: '${data.name}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'TerminalGrotesque'),
            )));
  }

  // description for the event
  Widget eventDescription(data) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.60,
            child: RichText(
                text: TextSpan(
                  text: '\n${data.description}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ))));
  }

  String formatDate(String unixDate) {
    var date =
    new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('EEE dd MMM').format(date);
    return formattedDate.toUpperCase();
  }

  String getTime(String unixDate) {
    var date =
    new DateTime.fromMillisecondsSinceEpoch(int.parse(unixDate) * 1000);
    date = date.toLocal();
    String formattedDate = DateFormat('hh:mm a').format(date);
    return formattedDate;
  }

  Widget eventTime(data) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '${getTime(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'TerminalGrotesque'),
          ),
          Text(
            '${formatDate(data.timestamp)}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.5,
                fontFamily: 'TerminalGrotesque'),
          ),
        ]);
  }

  // hyperlinked button for the event
  Widget zoomLink(data) {
    if (data.access_code == 2) {
      return IconButton(
          icon: new Image.asset(
            "lib/logos/hopinLogo.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),

          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    } else if (data.access_code == 1) {
      return IconButton(
          icon: Icon(
            Icons.videocam,
            color: Colors.white,
            size: 25,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    } else {
      return IconButton(
          icon: new Image.asset(
            "lib/logos/discordLogoWhite.png",
            width: 24,
            height: 24,
            color: Colors.white,
          ),
          tooltip: 'Zoom Link!',
          color: Color.fromARGB(255, 37, 130, 242),
          onPressed: () => launch('${data.zoom_link}'));
    }
  }

  Widget shareLink(data) {
    return IconButton(
      icon: Icon(
        Icons.share,
        color: Colors.white,
        size: 25,
      ),
      tooltip: 'Share Link!',
      color: Color.fromARGB(255, 37, 130, 242),
      onPressed: () {
        String text = 'Join ${data.name} at ' + '${data.zoom_link}';
        final RenderBox box = context.findRenderObject();
        Share.share(text,
            sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Scaffold(
        body: Container(
            child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TopBar(backflag: true),
                        Stack(
                          children: [
                            Column(
                                children:[
                                  SizedBox(height:screenHeight * 0.05),
                                  CustomPaint(
                                      size: Size(screenWidth, screenHeight * 0.75),
                                      painter: CurvedTop(color1: Theme.of(context).colorScheme.primary,
                                          color2: Theme.of(context).colorScheme.secondaryVariant)
                                  ),
                                ]
                            ),
                            //create new event button
                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                Container(
                                    width: screenWidth,
                                    padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                      ],
                                    )
                                ),
                                  GradBox(
                                    width: screenWidth * 0.9,
                                    height: 60,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NewEventScreen()),
                                      );
                                    },
                                    child: Text(
                                      "CREATE NEW EVENT",
                                      style: Theme.of(context).textTheme.headline2,
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxHeight: screenHeight*0.65
                                        ),
                                        child: ListView.builder(
                                          itemCount: eventData.length,
                                          itemBuilder: (BuildContext context, int index){
                                            return EventCard();
                                          },
                                        ),
                                      )
                                  )
                            ]),
                          ],
                        )
                      ],
                    )));
  }
}

class EventCard extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: GradBox(
            width: 100,
            height: 200,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                  children:[
                    SizedBox(
                      width: screenWidth * 0.5,
                      child:Text("[Event Name]",
                      style: Theme.of(context).textTheme.headline2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      )
                    ),
                    SizedBox(height: screenHeight*0.01),
                    SizedBox(
                        width: screenWidth * 0.4,
                        child:Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                            "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                            "Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                            "laboris nisi ut aliquip ex ea commodo consequat.",
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                    ),
                    Row(
                      children:[
                        SolidSquareButton(
                          image: "",
                          onPressed: null,
                        ),
                        SolidSquareButton(
                          image: "",
                          onPressed: null,
                        )
                      ]
                    )

                  ]
                    ),

                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      SizedBox(
                          width: screenWidth * 0.265,

                          height: 170,
                          child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                borderRadius: BorderRadius.circular(10)
                              )
                      )
                      )]
                )
              ],
            )
        )
    );
  }
}