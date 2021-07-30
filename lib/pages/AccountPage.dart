import 'package:astrologyapp/api/signinapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AccountPageWidget extends StatefulWidget {
  @override
  _AccountPageWidgetState createState() => _AccountPageWidgetState();
}

class _AccountPageWidgetState extends State<AccountPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 210,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment(-0.99, -0.95),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white,
                                        )
                                      ],
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF03DAC6),
                                          Color(0x8503DAC6)
                                        ],
                                        stops: [0, 1],
                                        begin: Alignment(0.07, -1),
                                        end: Alignment(-0.07, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(0.03, -0.66),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 25, 0, 5),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.photoURL!),
                                      radius: 40,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 140, 0, 0),
                                  child: Text(
                                    user.displayName!,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment(-1, 0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(10, 174, 0, 0),
                                    child: Text(
                                      user.email!,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 12, 0, 12),
                      child: Text(
                        'Account Settings',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: TextButton(
                                child: Text(
                                  'Payment History',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment(0.9, 0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: TextButton(
                                child: Text(
                                  'Meetings History',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment(0.9, 0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: TextButton(
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment(0.9, 0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     ListTile(
                  //       trailing: Icon(Icons.logout_outlined),
                  //       title: Text("Logout"),
                  //       onTap: () {

                  //       },
                  //     )
                  //   ],
                  // )
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: TextButton(
                                    onPressed: () {
                                      final provider =
                                          Provider.of<GoogleSignInProvider>(
                                              context,
                                              listen: false);
                                      provider.logout();
                                    },
                                    child: Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Align(
                                  alignment: Alignment(0.9, 0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.logout,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      final provider =
                                          Provider.of<GoogleSignInProvider>(
                                              context,
                                              listen: false);
                                      provider.logout();
                                    },
                                  ),
                                ),
                              )
                              // Expanded(
                              //   child: Align(
                              //     alignment: Alignment(0.9, 0),
                              //     child: Padding(
                              //       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              //       child: Icon(
                              //         Icons.logout,
                              //         color: Colors.white,
                              //         size: 18,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
