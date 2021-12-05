import 'dart:io';

import 'package:astrologyapp/ChatUtils/ChatScreen.dart';
import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/jitsiMeetUtils/meetModel..dart';
import 'package:astrologyapp/model/ChatModel.dart';
import 'package:astrologyapp/model/MeetingHistory.dart';
import 'package:astrologyapp/model/meetings.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  // String? currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ScrollController listScrollController = ScrollController();
  final user = FirebaseAuth.instance.currentUser!;
  late final meetings;
  SharedPreferences? prefs;
  bool timecheck = false;
  List<ChatModel> chatList = [];
  int _limit = 20;
  int _limitIncrement = 20;
  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
  ];

  get isEqualTo => null;

  @override
  void initState() {
    super.initState();
    meetings = Provider.of<List<Meetings>>(context, listen: false);
    registerNotification();
    getData();
    configLocalNotification();
    listScrollController.addListener(scrollListener);
  }

  getData() async {
    print(user.uid);
    FirebaseFirestore.instance.collection('messages').get().then((querySnap) {
      querySnap.docs.forEach((doc) {
        if (ChatModel.fromJson(doc.data()).idFrom == user.uid ||
            ChatModel.fromJson(doc.data()).idTo == user.uid) {
          chatList.add(ChatModel.fromJson(doc.data()));
        }
      });
      setState(() {});
    });
  }

  void registerNotification() {
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage: $message');
      if (message.notification != null) {
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('userschat')
          .doc(user.getIdToken().toString())
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      Platform.isAndroid ? 'com.dfa.chatdemo' : 'com.duytq.chatdemo',
      'Chat demo',
      'description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    print(remoteNotification);

    await flutterLocalNotificationsPlugin.show(
      0,
      remoteNotification.title,
      remoteNotification.body,
      platformChannelSpecifics,
      payload: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("gggggggggg ${meetings.length}");
    // currentUserId = user.getIdToken() as String?;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        actions: [
          Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AccountPageWidget()),
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
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Icon(
                  Icons.circle,
                  color: Color(0xFF28FF00),
                  size: 15,
                ),
              )
            ],
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          meetingcheck(),
          Container(
            child: chatList.length == 0
                ? Center(
                    child: Text(
                    "No Chat Data found!!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              color: Colors.black, // red as border color
                            ),
                            // color: Colors.deepPurple,
                          ),
                          child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Chat(
                                              name: chatList[index].idTo ==
                                                      user.uid
                                                  ? chatList[index].nameFrom
                                                  : chatList[index].nameTo,
                                              peerId: chatList[index].idTo ==
                                                      user.uid
                                                  ? chatList[index].idFrom
                                                  : chatList[index].idTo,
                                              image: chatList[index].idTo ==
                                                      user.uid
                                                  ? chatList[index].imageFrom
                                                  : chatList[index].imageTo,
                                            )));
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              contentPadding: EdgeInsets.all(8.0),
                              leading: Material(
                                child: chatList[index].imageTo.isNotEmpty
                                    ? Image.network(
                                        chatList[index].idTo == user.uid
                                            ? chatList[index].imageFrom
                                            : chatList[index].imageTo,
                                        fit: BoxFit.cover,
                                        width: 50.0,
                                        height: 50.0,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Container(
                                            width: 50,
                                            height: 50,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: primaryColor,
                                                value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null &&
                                                        loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, object, stackTrace) {
                                          return Icon(
                                            Icons.account_circle,
                                            size: 50.0,
                                            color: Colors.black,
                                          );
                                        },
                                      )
                                    : Icon(
                                        Icons.account_circle,
                                        size: 50.0,
                                        color: Colors.black,
                                      ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              title: Text(
                                chatList[index].idTo == user.uid
                                    ? chatList[index].nameFrom
                                    : chatList[index].nameTo,
                              ),
                              tileColor: Colors.white),
                        ),
                      );
                    },
                    itemCount: chatList.length),
          ),
        ],
      ),
    );
  }

  Widget meetingcheck() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: MeetingHistory.read(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 8.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var noteInfo = snapshot.data!.docs[index].data();
              // String docID = snapshot.data!.docs[index].id;
              String astrologerPhoto = noteInfo['astrologerphotoUrl'];
              String astrologerName = noteInfo['astrologername'];
              String astrologerEmail = noteInfo['astrologerEmail'];
              String paymentDescription = noteInfo['description'];
              String meetDate = noteInfo['meetDate'];
              Timestamp createdAt = noteInfo['paymentDateTime'];
              // String meetinglink = noteInfo['meetingLink'];
              String paymentId = noteInfo['paymentId'];
              String startTime = noteInfo['startTime'];
              String startEndTime = noteInfo['startEndTime'];

              String time = meetDate + " " + startTime;
              DateTime tempDate =
                  new DateFormat("dd/MM/yyyy hh:mm").parse(time);
              print(tempDate);
              final datetimemin = DateTime.now().difference(tempDate).inMinutes;
              final datetimeHR = DateTime.now().difference(tempDate).inHours;
              final datetimedays = DateTime.now().difference(tempDate).inDays;
              print(datetimedays + datetimeHR + datetimemin);

              if (datetimedays == 0) {
                while (datetimeHR <= 0) {
                  while (datetimemin > -5 && datetimemin < 35) {
                    timecheck = true;
                  }
                }
              } else {
                timecheck = false;
              }

              return timecheck
                  ? Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        // height: 160,
                        decoration: BoxDecoration(
                          // color: colors[i],
                          boxShadow: [
                            BoxShadow(
                              color: GradientTemplate
                                  .gradientTemplate[0].colors.last
                                  .withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2.5,
                              offset: Offset(3, 3),
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: GradientTemplate.gradientTemplate[0].colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: ExpansionTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Meeting Details",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 3,
                                        bottom: 8,
                                      ),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            'Date ',
                                            maxLines: 1,
                                            maxFontSize: 16,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          AutoSizeText(
                                            meetDate,
                                            maxLines: 1,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: Colors.white,
                                              // fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 3, bottom: 8),
                                      child: Row(
                                        children: [
                                          AutoSizeText(
                                            "Time ",
                                            maxLines: 1,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          AutoSizeText(
                                            startTime,
                                            maxLines: 1,
                                            maxFontSize: 14,
                                            style: TextStyle(
                                              color: Colors.white,
                                              // fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            child: ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                image: astrologerPhoto,
                                                placeholder:
                                                    'assets/images/bro.jpg',
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      'assets/images/bro.jpg',
                                                      fit: BoxFit.fitWidth);
                                                },
                                              ),
                                            ),
                                            radius: 20,
                                          ),
                                          CircleAvatar(
                                            child: ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                image: FirebaseAuth.instance
                                                    .currentUser!.photoURL!,
                                                placeholder:
                                                    'assets/images/bro.jpg',
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  return Image.asset(
                                                      'assets/images/bro.jpg',
                                                      fit: BoxFit.fitWidth);
                                                },
                                              ),
                                            ),
                                            radius: 20,
                                          ),
                                        ],
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            primary: Colors.amber),
                                        onPressed: () {
                                          MeetModel.joinMeeting(
                                              roomText:
                                                  "trymeetingboyyyyyyyyyyy",
                                              subjectText: "LOL",
                                              nameText:
                                                  user.displayName.toString(),
                                              emailText: user.email.toString(),
                                              isAudioOnly: false,
                                              isAudioMuted: true,
                                              isVideoMuted: true);
                                          // timecheck!
                                          //     ? _launchURL(meetlink)
                                          //     : Fluttertoast.showToast(
                                          //         msg: "meeting not Activated");
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        label: Text('Join'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Astrologer Name - ' + astrologerName,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 16)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('Description - ' + paymentDescription,
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 16)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  // Text('meetingId - ' + meetingId,
                                  //     style: TextStyle(
                                  //         color: Colors.white70, fontSize: 16)),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container();
            },
          );
        }

        return Container();
      },
    );
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
