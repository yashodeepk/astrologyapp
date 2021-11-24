import 'dart:math';

import 'package:astrologyapp/ChatUtils/ChatScreen.dart';
import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/GoogleMeetUtils/EventDetails.dart';
import 'package:astrologyapp/GoogleMeetUtils/calenderevent.dart';
import 'package:astrologyapp/GoogleMeetUtils/secrate.dart';
import 'package:astrologyapp/jitsiMeetUtils/meetingPage.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:astrologyapp/pages/ChatPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_color/random_color.dart';

Future<void> calender() async {
  var _clientID = new ClientId(Secret.getId(), "");
  const _scopes = const [cal.CalendarApi.calendarScope];
  await clientViaUserConsent(_clientID, _scopes, prompt).then(
      (AuthClient client) async {
    CalendarClient.calendar = cal.CalendarApi(client);
  }, onError: (e) {
    print("Error is " + e.toString());
  }).catchError((e) {
    print("Error in catchError " + e.toString());
  });
}

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class ConsultWidget extends StatefulWidget {
  static const String routeName = '/consultPage';

  @override
  _ConsultWidgetState createState() => _ConsultWidgetState();
}

class _ConsultWidgetState extends State<ConsultWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;
  var _controller = ScrollController();
  // RandomColor _randomColor = RandomColor();
  // List colors = [
  //   Colors.blue.shade900,
  //   Colors.blue.shade800,
  //   Colors.blueGrey.shade900,
  //   Colors.blueGrey.shade800,
  //   Colors.indigo.shade900,
  //   Colors.indigo.shade800,
  // ];
  Random random = new Random();
  List? astrologersList;

  @override
  void initState() {
    astrologersList = Provider.of<List<Astrologer>>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Consult',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPageWidget()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: CircleAvatar(
                child: ClipOval(
                  child: Image.network(user.photoURL!),
                ),
                radius: 18,
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        itemCount: astrologersList!.length,
        itemBuilder: (BuildContext context, int index) {
          // changeIndex();
          Astrologer astrologer = astrologersList![index];
          // Color _color = _randomColor.randomColor(
          //     colorHue: ColorHue.multiple(colorHues: [ColorHue.blue]),
          //     colorBrightness: ColorBrightness.multiple(colorBrightnessList: [
          //       ColorBrightness.dark,
          //       ColorBrightness.veryDark
          //     ]),
          //     colorSaturation: ColorSaturation.highSaturation);
          // setState(() => count = random.nextInt(3));

          return astrologerCard(astrologer,
              random.nextInt(GradientTemplate.gradientTemplate.length));
        },
      ),
    );
  }

  Widget astrologerCard(Astrologer astrologer, int i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: 180,
        decoration: BoxDecoration(
          // color: colors[i],
          boxShadow: [
            BoxShadow(
              color: GradientTemplate.gradientTemplate[i].colors.last
                  .withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2.5,
              offset: Offset(3, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: GradientTemplate.gradientTemplate[i].colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(8, 10, 0, 8),
                        child: CircleAvatar(
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              image: '${astrologer.photoUrl}',
                              placeholder: 'assets/images/bro.jpg',
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/bro.jpg',
                                    fit: BoxFit.fitWidth);
                              },
                            ),
                          ),
                          radius: 34,
                        ),
                        // child: CircleAvatar(
                        //   backgroundImage: CachedNetworkImageProvider(
                        //       '${astrologer.photoUrl}'),
                        //   radius: 30,
                        // ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          for (int i = 0; i < 5; i++)
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
                              child: Container(
                                // padding: EdgeInsets.fromLTRB(7.2, 0, 2, 0),
                                // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Icon(
                                  Icons.star_rate,
                                  color: astrologer.rating > i
                                      ? Color(0xFFFFD700)
                                      : Colors.grey,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 1, 0, 5),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            astrologer.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    astrologer.expertise,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    "Exp: " +
                                        astrologer.experience.toString() +
                                        ' Years',
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13,
                                        fontStyle: FontStyle.italic),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'Fess  - ${astrologer.fees} ₹',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //     child: TextButton.icon(
                  //       onPressed: () {
                  //         calender();
                  //         Navigator.of(context).pushNamed(
                  //             DashboardScreen.routeName,
                  //             arguments: astrologer.email);
                  //       },
                  //       label: Text('Book Meeting'),
                  //       icon: Icon(
                  //         Icons.call_rounded,
                  //         size: 15,
                  //       ),
                  //       style: TextButton.styleFrom(
                  //         // padding: EdgeInsets.all(8),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         primary: Colors.white,
                  //         backgroundColor: Colors.orange,
                  //         textStyle: TextStyle(
                  //           fontWeight: FontWeight.normal,
                  //           fontSize: 16,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Meeting()
                                  // Chat(
                                  //       name: astrologer.name!,
                                  //       peerId: astrologer.id!,
                                  //       image: astrologer.photoUrl,
                                  //     )
                                  ));
                        },
                        label: Text('Message'),
                        icon: Icon(
                          Icons.message_rounded,
                          size: 15,
                        ),
                        style: TextButton.styleFrom(
                          // padding: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Colors.white,
                          backgroundColor: Colors.orange,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
