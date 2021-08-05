import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final currentusers = FirebaseAuth.instance.currentUser!;

  Future<void> storeage() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentusers.displayName)
        .set({
      'username': currentusers.displayName!.trim(),
      'email': currentusers.email!.trim(),
      'imageUrl': currentusers.photoURL,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storeage();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[400],
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Horoscope',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        // flexibleSpace:
        actions: [],
        elevation: 0,
      ),
      backgroundColor: Colors.lightBlueAccent[400],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('FloatingActionButton pressed ...');
        },
        backgroundColor: Colors.lightBlueAccent[400],
        child: Icon(
          Icons.edit,
          color: Colors.black,
        ),
        elevation: 8,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent[400],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        // width: 80,
                        // height: 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/1.png'),
                        )),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 5),
                          child: Text(
                            user.displayName!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text(
                            'Capricorn',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
              //   child: Text(
              //     user.displayName!,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontWeight: FontWeight.w500,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 1.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // gradient: LinearGradient(
                    //     begin: Alignment.centerLeft,
                    //     end: Alignment.centerRight,
                    //     colors: [Color(0xfffe8c00), Color(0xfff83600)]),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(42),
                        topRight: Radius.circular(42)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.circle,
                              color: Color(0xFF22262B),
                              size: 22,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: AutoSizeText(
                                'Daily Horoscope',
                                style: TextStyle(
                                  color: Color(0xFF22262B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.done,
                              color: Color(0xFF22262B),
                              size: 18,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: AutoSizeText(
                                'you will rock today',
                                style: TextStyle(
                                  color: Color(0xFF22262B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.done,
                              color: Color(0xFF22262B),
                              size: 18,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: AutoSizeText(
                                'you will rock today',
                                style: TextStyle(
                                  color: Color(0xFF22262B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.done,
                              color: Color(0xFF22262B),
                              size: 18,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: AutoSizeText(
                                'you will rock today',
                                style: TextStyle(
                                  color: Color(0xFF22262B),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
