import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/jitsiMeetUtils/meetModel..dart';
import 'package:astrologyapp/model/MeetingHistory.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class MeetingHistoryPage extends StatefulWidget {
  static String? useremail;

  static const String routeName = '/meetingHitoryPage';
  const MeetingHistoryPage({Key? key}) : super(key: key);

  @override
  _MeetingHistoryPageState createState() => _MeetingHistoryPageState();
}

class _MeetingHistoryPageState extends State<MeetingHistoryPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  bool timecheck = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meeting History',
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: MeetingHistory.read(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 8.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var noteInfo = snapshot.data!.docs[index].data();
                // String docID = snapshot.data!.docs[index].id;
                String astrologerPhoto = noteInfo['astrologerphotoUrl'];
                String astrologerName = noteInfo['astrologername'];
                String astrologerEmail = noteInfo['astrologerEmail'];
                String userphotoUrl = noteInfo['userphotoUrl'];
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
                final datetimemin =
                    DateTime.now().difference(tempDate).inMinutes;
                final datetimeHR = DateTime.now().difference(tempDate).inHours;
                final datetimedays = DateTime.now().difference(tempDate).inDays;
                print("D " +
                    datetimedays.toString() +
                    "H " +
                    datetimeHR.toString() +
                    "M " +
                    datetimemin.toString());

                if (datetimedays == 0) {
                  print(1);
                  if (datetimeHR >= 0) {
                    print(2);
                    if (datetimemin > -5 && datetimemin < 35) {
                      print(3);
                      timecheck = true;
                    }
                  }
                } else {
                  timecheck = false;
                }
                print("timecheck " + timecheck.toString());

                return Padding(
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
                                  padding:
                                      const EdgeInsets.only(top: 3, bottom: 8),
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
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
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
                                            image: userphotoUrl,
                                            placeholder:
                                                'assets/images/bro.jpg',
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
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
                                      timecheck
                                          ? Fluttertoast.showToast(
                                              msg: "Meeting is not active")
                                          : MeetModel.joinMeeting(
                                              roomText: "trymeeting",
                                              subjectText: "LOL",
                                              nameText: currentUser!.displayName
                                                  .toString(),
                                              emailText:
                                                  currentUser!.email.toString(),
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
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue.shade900,
              ),
            ),
          );
        },
      ),
    );
  }
}
