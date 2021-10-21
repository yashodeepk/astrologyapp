import 'dart:ui';

// import 'package:astrologyapp/api/signinapi.dart';
import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/homepageutils/horoscopeselectutils.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/painting/gradient.dart' as gradiantss;

String? userType;
String? email;

class HomePageWidget extends StatefulWidget {
  static const String routeName = '/HomePageWidget';

  //static variable for document name
  static String zodiacSignName = 'Aquarius';

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with WidgetsBindingObserver {
  final user = FirebaseAuth.instance.currentUser!;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final firestoreInstance = FirebaseFirestore.instance;
  var _controller = ScrollController();
  String? love;
  String? health;
  String? horoscope;
  bool checkdata = true;
  List<Astrologer>? astrologersList;
  bool isUserAstrologer = false;
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
    WidgetsBinding.instance!.addObserver(this);
    checkForUserAstrologer();
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

  void checkForUserAstrologer() {
    astrologersList = Provider.of<List<Astrologer>>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    for (var i = 0; i < astrologersList!.length; i++) {
      if (astrologersList![i].id == user!.uid) {
        isUserAstrologer = true;
      }
    }
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      if (user != null) {
        if (isUserAstrologer == true) {
          firestoreInstance.collection("Astrologer").doc(user.email).update(
            {"isOnline": true},
          );
        } else {
          firestoreInstance.collection("users").doc(user.email).update(
            {"isOnline": true},
          );
        }
      }
    } else {
      if (user != null) {
        if (isUserAstrologer == true) {
          firestoreInstance.collection("Astrologer").doc(user.email).update(
            {"isOnline": false},
          );
        } else {
          firestoreInstance.collection("users").doc(user.email).update(
            {"isOnline": false},
          );
        }
      }
    }
  }

  //get user type from shared prefs
  getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('type')) {
      userType = preferences.getString('type');
    }
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
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
              splashColor: Colors.transparent,
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

        // backgroundColor: ,
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
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            // color: Colors.blue[900],
            boxShadow: [
              BoxShadow(
                color: GradientTemplate.gradientTemplate[0].colors.last
                    .withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 2.5,
                offset: Offset(3, 3),
              ),
            ],
            gradient: gradiantss.LinearGradient(
              colors: GradientTemplate.gradientTemplate[0].colors,
              begin: Alignment.bottomCenter,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(context).size.height * 0.16, 0, 10),
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
                          placeHolder: CircularProgressIndicator(
                            color: Colors.black,
                          ),
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
                    physics: BouncingScrollPhysics(),
                    controller: _controller,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 60),
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
        ));
  }
}
