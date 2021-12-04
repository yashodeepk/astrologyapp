import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/MeetingHistory.dart';
import 'package:astrologyapp/model/PaymentHistory.dart';
import 'package:astrologyapp/pages/schedules_page/schedules.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'HomePage.dart';

class AccountPageWidget extends StatefulWidget {
  static const String routeName = '/accountPage';

  @override
  _AccountPageWidgetState createState() => _AccountPageWidgetState();
}

class _AccountPageWidgetState extends State<AccountPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            // color: Colors.blue[900],
            padding: EdgeInsets.only(top: 80),
            decoration: BoxDecoration(
              // color: colors[i],
              boxShadow: [
                BoxShadow(
                  color: GradientTemplate.gradientTemplate[0].colors.last
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
              // borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                    radius: 50,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Text(
                    user.displayName!,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 15),
                  child: Text(
                    user.email!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                //check if user type is astrologer and add slot
                userType == astrologerX
                    ? ListTile(
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black,
                          size: 18,
                        ),
                        title: Text(
                          addSchedule,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        onTap: () async {
                          //push to schedules
                          Navigator.of(context)
                              .pushNamed(SchedulesPage.routeName);
                          /*  showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => AddDayAndTimeAvailable())*/
                        },
                      )
                    : Container(),
                ListTile(
                  title: Text(
                    'Payment History',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 18,
                  ),
                  onTap: () {
                    PaymentHistory.checkPayment(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Meetings History',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 18,
                  ),
                  onTap: () {
                    MeetingHistory.checkMeetings(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.logout,
                    color: Colors.black,
                    size: 18,
                  ),
                  onTap: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
