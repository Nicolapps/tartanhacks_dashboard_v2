import 'package:barras/barras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/pages/qr_scan_config.dart';
import 'custom_widgets.dart';

class QRPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    final _eventIDController = TextEditingController();

    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TopBar(backflag: true),
                        Stack(
                          children: [
                            Column(children: [
                              SizedBox(height: screenHeight * 0.05),
                              CustomPaint(
                                  size: Size(screenWidth, screenHeight * 0.75),
                                  painter: CurvedTop(
                                      color1: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                      color2:
                                      Theme.of(context).colorScheme.primary,
                                      reverse: true)),
                            ]),
                            Container(
                                alignment: Alignment.center,
                                height: screenHeight * 0.78,
                                padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IDCheckInHeader(_eventIDController),
                                    QREnlarged(onPressed: () async {
                                      // TODO Handle scanned data somehow
                                      final String data = await Barras.scan(context);
                                    },)
                                  ],
                                ))
                          ],
                        )
                      ],
                    )))));
  }
}

class IDCheckInHeader extends StatelessWidget {
  final _eventIDController;

  IDCheckInHeader(this._eventIDController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Check in with event ID",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 20
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: _eventIDController,
          enableSuggestions: false,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 5,),
        Align(
          alignment: Alignment.bottomRight,
          child: SolidButton(
            onPressed: () {},
            child: Icon(
              Icons.keyboard_return_rounded,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class QREnlarged extends StatelessWidget {
  final Function onPressed;

  QREnlarged({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "YOUR QR CODE",
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(height: 10,),
        AspectRatio(
            aspectRatio: 1,
            child: GradBox(
              width: double.infinity,
              child: FutureBuilder(
                future: getCurrentUserID(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else if (snapshot.connectionState == ConnectionState.done && snapshot.data!=null)
                    return QrImage(
                      data: snapshot.data,
                      version: QrVersions.auto,
                      foregroundColor: Colors.black,
                    );
                  else return Center(child: Text("Error"),);
                },
              ),
            )
        ),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 45,
                child: SolidButton(
                  onPressed: onPressed,
                  text: "To Scanner",
                ),
              ),
            ),
            SizedBox(width: 50,),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 45,
                child: SolidButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:
                      (context) => ScanConfigPage()));
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}


