import 'dart:io';

import 'package:astrologyapp/ChatUtils/ChatScreen.dart';
import 'package:astrologyapp/ChatUtils/loading.dart';
import 'package:astrologyapp/ChatUtils/userchat.dart';
import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/actions/actions.dart';
import 'package:astrologyapp/model/ChatModel.dart';
import 'package:astrologyapp/model/meetings.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => AccountPageWidget()),
                    //   );
                    // },
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
      body: Container(
        child: chatList.length == 0
            ? Center(
                child: Text(
                "No Chat Data found!!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ))
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Chat(
                                        name: chatList[index].idTo == user.uid
                                            ? chatList[index].nameFrom
                                            : chatList[index].nameTo,
                                        peerId: chatList[index].idTo == user.uid
                                            ? chatList[index].idFrom
                                            : chatList[index].idTo,
                                        image: chatList[index].idTo == user.uid
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
                                    if (loadingProgress == null) return child;
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
                                  errorBuilder: (context, object, stackTrace) {
                                    return Icon(
                                      Icons.account_circle,
                                      size: 50.0,
                                      color: greyColor,
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 50.0,
                                  color: greyColor,
                                ),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        title: Text(
                          chatList[index].idTo == user.uid
                              ? chatList[index].nameFrom
                              : chatList[index].nameTo,
                        ),
                        tileColor: Colors.grey[200]),
                  );
                },
                itemCount: chatList.length),
      ),
    );

    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData.light(),
    //   home: Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.white,
    //       automaticallyImplyLeading: false,
    //       title: Text(
    //         'Chats',
    //         style: TextStyle(
    //             color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
    //       ),
    //       actions: [
    //         Stack(
    //           children: [
    //             Column(
    //               mainAxisSize: MainAxisSize.max,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 InkWell(
    //                   onTap: () {
    //                     Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (context) => AccountPageWidget()),
    //                     );
    //                   },
    //                   child: Padding(
    //                     padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
    //                     child: CircleAvatar(
    //                       child: ClipOval(
    //                         child: Image.network(user.photoURL!),
    //                       ),
    //                       radius: 18,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             Padding(
    //               padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
    //               child: Icon(
    //                 Icons.circle,
    //                 color: Color(0xFF28FF00),
    //                 size: 15,
    //               ),
    //             )
    //           ],
    //         ),
    //       ],
    //       centerTitle: true,
    //       elevation: 0,
    //     ),
    //     backgroundColor: Colors.white,
    //     body: Column(
    //       mainAxisSize: MainAxisSize.max,
    //       children: [
    //         ListView.builder(
    //           itemBuilder: (context, index) {
    //             Meetings meet = meetings[index];

    //             return Expanded(
    //               child: SingleChildScrollView(
    //                 child: Column(
    //                   mainAxisSize: MainAxisSize.min,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Padding(
    //                       padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
    //                       child: Container(
    //                         width: double.infinity,
    //                         height: 110,
    //                         decoration: BoxDecoration(
    //                           color: Colors.lightBlueAccent[400],
    //                           borderRadius: BorderRadius.circular(24),
    //                         ),
    //                         child: Padding(
    //                           padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
    //                           child: Row(
    //                             mainAxisSize: MainAxisSize.max,
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceEvenly,
    //                             crossAxisAlignment: CrossAxisAlignment.end,
    //                             children: [
    //                               Column(
    //                                 mainAxisSize: MainAxisSize.max,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Padding(
    //                                     padding:
    //                                         EdgeInsets.fromLTRB(0, 10, 0, 0),
    //                                     child: Text(
    //                                       'Scheduled Meeting',
    //                                       style: TextStyle(
    //                                         color: Colors.black,
    //                                         fontWeight: FontWeight.w600,
    //                                         fontSize: 20,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Padding(
    //                                     padding:
    //                                         EdgeInsets.fromLTRB(5, 10, 0, 0),
    //                                     child: Text(
    //                                       'Date - ${meet.scheduledDate}',
    //                                       style: TextStyle(
    //                                         color: Colors.black,
    //                                         fontWeight: FontWeight.w500,
    //                                         fontSize: 16,
    //                                       ),
    //                                     ),
    //                                   ),
    //                                   Padding(
    //                                     padding:
    //                                         EdgeInsets.fromLTRB(5, 5, 0, 0),
    //                                     child: Text(
    //                                       'Time - ${meet.scheduledTime}',
    //                                       style: TextStyle(
    //                                         color: Colors.black,
    //                                         fontWeight: FontWeight.w500,
    //                                         fontSize: 16,
    //                                       ),
    //                                     ),
    //                                   )
    //                                 ],
    //                               ),
    //                               Padding(
    //                                 padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
    //                                 child: SingleChildScrollView(
    //                                   child: Column(
    //                                     mainAxisSize: MainAxisSize.max,
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     children: [
    //                                       Padding(
    //                                         padding:
    //                                             EdgeInsets.fromLTRB(0, 0, 0, 0),
    //                                         child: Row(
    //                                           mainAxisSize: MainAxisSize.max,
    //                                           children: [
    //                                             CircleAvatar(
    //                                                 backgroundImage:
    //                                                     CachedNetworkImageProvider(
    //                                                         '${meet.astrologerPhoto}'),
    //                                                 radius: 20),
    //                                             CircleAvatar(
    //                                                 backgroundImage:
    //                                                     CachedNetworkImageProvider(
    //                                                         '${FirebaseAuth.instance.currentUser!.photoURL}'),
    //                                                 radius: 20),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       ElevatedButton.icon(
    //                                         style: ElevatedButton.styleFrom(
    //                                             shape: RoundedRectangleBorder(
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         20)),
    //                                             primary: Color(0xff4c3cb0)),
    //                                         onPressed: () async {
    //                                           //open google meet link
    //                                           await ShowAction.launchUrl(
    //                                                   meet.meetingLink)
    //                                               .then((value) {});

    //                                           /*    Navigator.of(context)
    //                                               .push(MaterialPageRoute(
    //                                             builder: (context) => Chat(
    //                                               peerId: userType == userX
    //                                                   ? '${meet.astrologerId}'
    //                                                   : '${meet.userId}',
    //                                               peerAvatar: '',
    //                                             ),
    //                                           ));*/
    //                                         },
    //                                         icon: Icon(
    //                                           Icons.arrow_forward_ios,
    //                                           color: Colors.white,
    //                                           size: 16,
    //                                         ),
    //                                         label: Text('join'),
    //                                       )
    //                                     ],
    //                                   ),
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     // ChatScreen(currentUserId: prefs!.getString('id') ?? ""),
    //                     // ListView(
    //                     //   shrinkWrap: true,
    //                     //   children: [
    //                     //     InkWell(
    //                     //       onTap: () async {
    //                     //         prefs = await SharedPreferences.getInstance();
    //                     //         Navigator.push(
    //                     //             context,
    //                     //             MaterialPageRoute(
    //                     //                 builder: (context) => ChatScreen(
    //                     //                     currentUserId:
    //                     //                         prefs!.getString('id') ?? "")));
    //                     //       },
    //                     //       child: Padding(
    //                     //         padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
    //                     //         child: Row(
    //                     //           mainAxisSize: MainAxisSize.max,
    //                     //           children: [
    //                     //             Container(
    //                     //               width: MediaQuery.of(context).size.width - 20,
    //                     //               height: 80,
    //                     //               decoration: BoxDecoration(
    //                     //                 color: Colors.white,
    //                     //                 border: Border(
    //                     //                   bottom: BorderSide(
    //                     //                     color: Colors.black,
    //                     //                     width: 1,
    //                     //                   ),
    //                     //                 ),
    //                     //               ),
    //                     //               child: Row(
    //                     //                 mainAxisSize: MainAxisSize.max,
    //                     //                 children: [
    //                     //                   Padding(
    //                     //                     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //                     //                     child: Stack(
    //                     //                       children: [
    //                     //                         Padding(
    //                     //                           padding:
    //                     //                               EdgeInsets.fromLTRB(8, 0, 8, 0),
    //                     //                           child: Column(
    //                     //                             mainAxisSize: MainAxisSize.max,
    //                     //                             mainAxisAlignment:
    //                     //                                 MainAxisAlignment.center,
    //                     //                             children: [
    //                     //                               Container(
    //                     //                                 width: 60,
    //                     //                                 height: 60,
    //                     //                                 clipBehavior: Clip.antiAlias,
    //                     //                                 decoration: BoxDecoration(
    //                     //                                   shape: BoxShape.circle,
    //                     //                                 ),
    //                     //                                 child: Image.asset(
    //                     //                                   'assets/bro.jpg',
    //                     //                                 ),
    //                     //                               )
    //                     //                             ],
    //                     //                           ),
    //                     //                         ),
    //                     //                         Padding(
    //                     //                           padding: EdgeInsets.fromLTRB(
    //                     //                               10, 1, 0, 0),
    //                     //                           child: Icon(
    //                     //                             Icons.circle,
    //                     //                             color: Color(0xFF28FF00),
    //                     //                             size: 24,
    //                     //                           ),
    //                     //                         )
    //                     //                       ],
    //                     //                     ),
    //                     //                   ),
    //                     //                   Expanded(
    //                     //                     child: Column(
    //                     //                       mainAxisSize: MainAxisSize.max,
    //                     //                       mainAxisAlignment:
    //                     //                           MainAxisAlignment.center,
    //                     //                       children: [
    //                     //                         Row(
    //                     //                           mainAxisSize: MainAxisSize.max,
    //                     //                           children: [
    //                     //                             Text(
    //                     //                               'Kartik',
    //                     //                               style: TextStyle(
    //                     //                                 color: Colors.black,
    //                     //                                 fontSize: 18,
    //                     //                               ),
    //                     //                             )
    //                     //                           ],
    //                     //                         ),
    //                     //                         Row(
    //                     //                           mainAxisSize: MainAxisSize.max,
    //                     //                           children: [
    //                     //                             Expanded(
    //                     //                               child: Padding(
    //                     //                                 padding: EdgeInsets.fromLTRB(
    //                     //                                     0, 4, 4, 0),
    //                     //                                 child: Text(
    //                     //                                   'Hey Can i Help you',
    //                     //                                   style: TextStyle(
    //                     //                                     color: Colors.grey[700],
    //                     //                                     fontWeight:
    //                     //                                         FontWeight.w500,
    //                     //                                     fontSize: 14,
    //                     //                                   ),
    //                     //                                 ),
    //                     //                               ),
    //                     //                             )
    //                     //                           ],
    //                     //                         )
    //                     //                       ],
    //                     //                     ),
    //                     //                   ),
    //                     //                 ],
    //                     //               ),
    //                     //             )
    //                     //           ],
    //                     //         ),
    //                     //       ),
    //                     //     ),
    //                     //   ],
    //                     // )
    //                     Container(
    //                       child: StreamBuilder<QuerySnapshot>(
    //                         stream: FirebaseFirestore.instance
    //                             .collection('astrologer')
    //                             .limit(_limit)
    //                             .snapshots(),
    //                         builder: (BuildContext context,
    //                             AsyncSnapshot<QuerySnapshot> snapshot) {
    //                           if (snapshot.hasData) {
    //                             return ListView.builder(
    //                               shrinkWrap: true,
    //                               padding: EdgeInsets.all(10.0),
    //                               itemBuilder: (context, index) => buildItem(
    //                                   context, snapshot.data?.docs[index]),
    //                               itemCount: snapshot.data?.docs.length,
    //                               controller: listScrollController,
    //                             );
    //                           } else {
    //                             return Center(
    //                               child: CircularProgressIndicator(
    //                                 valueColor: AlwaysStoppedAnimation<Color>(
    //                                     primaryColor),
    //                               ),
    //                             );
    //                           }
    //                         },
    //                       ),
    //                     ),

    //                     // Loading
    //                     Positioned(
    //                       child: isLoading ? const Loading() : Container(),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //           itemCount: meetings.length,
    //           shrinkWrap: true,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == user.getIdToken()) {
        return SizedBox.shrink();
      } else {
        return Container(
          child: TextButton(
            child: Row(
              children: <Widget>[
                Material(
                  child: userChat.photoUrl.isNotEmpty
                      ? Image.network(
                          userChat.photoUrl,
                          fit: BoxFit.cover,
                          width: 50.0,
                          height: 50.0,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 50,
                              height: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 50.0,
                              color: greyColor,
                            );
                          },
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: greyColor,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                Flexible(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            'name: ${userChat.name}',
                            maxLines: 1,
                            style: TextStyle(color: primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                        ),
                        Container(
                          child: Text(
                            'About me: ${userChat.aboutMe}',
                            maxLines: 1,
                            style: TextStyle(color: primaryColor),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        )
                      ],
                    ),
                    margin: EdgeInsets.only(left: 20.0),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Chat(
              //       peerId: userChat.id,
              //       peerAvatar: userChat.photoUrl,
              //     ),
              //   ),
              // );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(greyColor2),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }
}

class Choice {
  const Choice({required this.title, required this.icon});

  final String title;
  final IconData icon;
}
