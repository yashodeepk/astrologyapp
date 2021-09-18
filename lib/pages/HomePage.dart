import 'dart:ui';

// import 'package:astrologyapp/api/signinapi.dart';
import 'package:astrologyapp/homepageutils/horoscopeselectutils.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? userType;
String? email;

class HomePageWidget extends StatefulWidget {
  static const String routeName = '/HomePageWidget';

  //static variable for document name
  static String zodiacSignName = 'Aquarius';

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final user = FirebaseAuth.instance.currentUser!;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final firestoreInstance = FirebaseFirestore.instance;
  String? love;
  String? health;
  String? horoscope;
  bool checkdata = true;

  // Future<void> storeage() async {
  //   await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
  //     "name": user.displayName,
  //     "email": user.email,
  //     "status": "Unavalible",
  //     "uid": _auth.currentUser!.uid,
  //   });
  // }

  @override
  void initState() {
    super.initState();
    setState(() {
      email = user.email;
    });

    getUserType();
    firestoreInstance
        .collection("horoscope")
        .doc(HomePageWidget.zodiacSignName)
        .get()
        .then((value) {
      setState(() {
        horoscope = value.data()!['General Horoscope'];
        health = value.data()!['Health'];
        love = value.data()!['Love'];
        checkdata = false;
      });
    });
  }

  //get user type from shared prefs
  getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('type')) {
      userType = preferences.getString('type');
    }

    print('type $userType');
  }

  // void handleClick(String value) {
  //   switch (value) {
  //     case 'Logout':
  //       break;
  //     case 'Account':
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, 9, 30);
    final format = DateFormat.yMMMMEEEEd(); //"6:00 AM"
    print(
        " hello  ${dt.millisecondsSinceEpoch} --- fff ${DateTime.fromMillisecondsSinceEpoch(dt.millisecondsSinceEpoch)}");

    print(TimeOfDay.now().replacing(hour: 9, minute: 30).format(context));
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Horoscope',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          // flexibleSpace:
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AccountPageWidget.routeName,
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
          elevation: 0,
        ),
        backgroundColor: Colors.blue[900],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                // barrierColor: Colors.black,
                context: context,
                builder: (context) => SingleChildScrollView(
                  child: HorescopeWidget(),
                ));
            print('FloatingActionButton pressed ...');
          },
          backgroundColor: Colors.blue[900],
          child: Icon(
            Icons.select_all,
            color: Colors.white,
          ),
          elevation: 8,
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2.6,
                          height: MediaQuery.of(context).size.width / 2.6,
                          child: RiveAnimation.asset(
                            zodiacsign,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // child: CircleAvatar(
                        //   radius: 50,
                        //   backgroundImage: AssetImage('assets/1.png'),
                        // ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                        child: Text(
                          zodiacsignname,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                                  child: AutoSizeText(
                                    'Love and Heath',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                checkdata
                                    ? Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                )
                                    : Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          love!,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        AutoSizeText(
                                          '% Love',
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        AutoSizeText(
                                          health!,
                                          style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                        AutoSizeText(
                                          '% Health',
                                          style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 8),
                                  child: AutoSizeText(
                                    'General Horoscope',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 5, 10, 15),
                                  child: AutoSizeText(
                                    horoscope ?? "Loading...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
