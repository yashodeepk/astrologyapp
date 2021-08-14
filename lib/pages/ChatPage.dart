import 'package:astrologyapp/ChatUtils/ChatScreen.dart';
import 'package:astrologyapp/ChatUtils/home.dart';
import 'package:astrologyapp/ChatUtils/loading.dart';
import 'package:astrologyapp/ChatUtils/userchat.dart';
import 'package:astrologyapp/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  User? currentUser;
  int _limit = 20;
  int _limitIncrement = 20;
  final ScrollController listScrollController = ScrollController();

  // void isSignedIn() async {
  //   this.setState(() {
  //     isLoading = true;
  //   });

  //   prefs = await SharedPreferences.getInstance();

  //   if (isLoggedIn && prefs?.getString('id') != null) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) =>
  //               ChatScreen(currentUserId: prefs!.getString('id') ?? "")),
  //     );
  //   }

  //   this.setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,
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
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user.photoURL!),
                        radius: 20,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 30, 0, 0),
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        width: double.infinity,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent[400],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      'Scheduled Meeting',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                                    child: Text(
                                      'Date - 1/6/2021',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                                    child: Text(
                                      'Time - 05:30 PM',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            CircleAvatar(
                                                backgroundImage:
                                                    AssetImage('assets/3.jpg'),
                                                radius: 20),
                                            CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/bro.jpg'),
                                                radius: 20),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            primary: Color(0xff4c3cb0)),
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        label: Text('join'),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // ChatScreen(currentUserId: prefs!.getString('id') ?? ""),
                    // ListView(
                    //   shrinkWrap: true,
                    //   children: [
                    //     InkWell(
                    //       onTap: () async {
                    //         prefs = await SharedPreferences.getInstance();
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => ChatScreen(
                    //                     currentUserId:
                    //                         prefs!.getString('id') ?? "")));
                    //       },
                    //       child: Padding(
                    //         padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    //         child: Row(
                    //           mainAxisSize: MainAxisSize.max,
                    //           children: [
                    //             Container(
                    //               width: MediaQuery.of(context).size.width - 20,
                    //               height: 80,
                    //               decoration: BoxDecoration(
                    //                 color: Colors.white,
                    //                 border: Border(
                    //                   bottom: BorderSide(
                    //                     color: Colors.black,
                    //                     width: 1,
                    //                   ),
                    //                 ),
                    //               ),
                    //               child: Row(
                    //                 mainAxisSize: MainAxisSize.max,
                    //                 children: [
                    //                   Padding(
                    //                     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    //                     child: Stack(
                    //                       children: [
                    //                         Padding(
                    //                           padding:
                    //                               EdgeInsets.fromLTRB(8, 0, 8, 0),
                    //                           child: Column(
                    //                             mainAxisSize: MainAxisSize.max,
                    //                             mainAxisAlignment:
                    //                                 MainAxisAlignment.center,
                    //                             children: [
                    //                               Container(
                    //                                 width: 60,
                    //                                 height: 60,
                    //                                 clipBehavior: Clip.antiAlias,
                    //                                 decoration: BoxDecoration(
                    //                                   shape: BoxShape.circle,
                    //                                 ),
                    //                                 child: Image.asset(
                    //                                   'assets/bro.jpg',
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         Padding(
                    //                           padding: EdgeInsets.fromLTRB(
                    //                               10, 1, 0, 0),
                    //                           child: Icon(
                    //                             Icons.circle,
                    //                             color: Color(0xFF28FF00),
                    //                             size: 24,
                    //                           ),
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   Expanded(
                    //                     child: Column(
                    //                       mainAxisSize: MainAxisSize.max,
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         Row(
                    //                           mainAxisSize: MainAxisSize.max,
                    //                           children: [
                    //                             Text(
                    //                               'Kartik',
                    //                               style: TextStyle(
                    //                                 color: Colors.black,
                    //                                 fontSize: 18,
                    //                               ),
                    //                             )
                    //                           ],
                    //                         ),
                    //                         Row(
                    //                           mainAxisSize: MainAxisSize.max,
                    //                           children: [
                    //                             Expanded(
                    //                               child: Padding(
                    //                                 padding: EdgeInsets.fromLTRB(
                    //                                     0, 4, 4, 0),
                    //                                 child: Text(
                    //                                   'Hey Can i Help you',
                    //                                   style: TextStyle(
                    //                                     color: Colors.grey[700],
                    //                                     fontWeight:
                    //                                         FontWeight.w500,
                    //                                     fontSize: 14,
                    //                                   ),
                    //                                 ),
                    //                               ),
                    //                             )
                    //                           ],
                    //                         )
                    //                       ],
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )
                    Container(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .limit(_limit)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(10.0),
                              itemBuilder: (context, index) => buildItem(
                                  context, snapshot.data?.docs[index]),
                              itemCount: snapshot.data?.docs.length,
                              controller: listScrollController,
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    // Loading
                    Positioned(
                      child: isLoading ? const Loading() : Container(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot? document) {
    if (document != null) {
      UserChat userChat = UserChat.fromDocument(document);
      if (userChat.id == prefs!.getString('id')) {
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
                            'Nickname: ${userChat.nickname}',
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat(
                    peerId: userChat.id,
                    peerAvatar: userChat.photoUrl,
                  ),
                ),
              );
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
