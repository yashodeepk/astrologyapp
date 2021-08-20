import 'dart:ui';

import 'package:astrologyapp/ChatUtils/userchat.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AstrologerinfoWidget extends StatefulWidget {
  @override
  _AstrologerinfoWidgetState createState() => _AstrologerinfoWidgetState();
}

class _AstrologerinfoWidgetState extends State<AstrologerinfoWidget> {
  TextEditingController nametextController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  User? currentUser;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    isLoading = true;

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        // Check is already sign up
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('astrologers')
            .where('id', isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.length == 0) {
          // Update data to server if new user
          FirebaseFirestore.instance
              .collection('astrologers')
              .doc(firebaseUser.uid)
              .set({
            'name': firebaseUser.displayName,
            'photoUrl': firebaseUser.photoURL,
            'id': firebaseUser.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'about': experienceController,
            'chattingWith': null
          });

          // Write data to local
          currentUser = firebaseUser;
          await prefs?.setString('id', currentUser!.uid);
          await prefs?.setString('name', currentUser!.displayName ?? "");
          await prefs?.setString('photoUrl', currentUser!.photoURL ?? "");
        } else {
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);
          // Write data to local
          await prefs?.setString('id', userChat.id);
          await prefs?.setString('name', userChat.name);
          await prefs?.setString('photoUrl', userChat.photoUrl);
          await prefs?.setString('aboutMe', userChat.aboutMe);
        }
        Fluttertoast.showToast(msg: "Sign in success");
        isLoading = false;
      } else {
        Fluttertoast.showToast(msg: "Sign in fail");
        isLoading = false;
      }
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(msg: "Can not init google sign in");
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          // height: MediaQuery.of(context).size.height / 1.5,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    'Please fill all details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: nametextController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter the Full Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: contactController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Contact number',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        LineIcons.mobilePhone,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter the Contact number';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: experienceController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Experience in years',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        LineIcons.clock,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter the Experience in years';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 30, 15, 150),
                  child: TextButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin();
                        // storeage("normaluser");
                        print('login pressed ...');
                      }
                    },
                    label: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Save & Login ',
                          style: TextStyle(color: Colors.white),
                        ),
                        Icon(
                          LineIcons.googlePlus,
                          color: Colors.white,
                        )
                      ],
                    )),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      fixedSize: Size(300, 45),
                      primary: Colors.black87,
                      backgroundColor: Colors.blue[900],
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    icon: Icon(
                      LineIcons.alternateSignIn,
                      color: Colors.white,
                    ),
                  ),
                ),
                // TextButton(
                //   onPressed: () {
                //     // final provider =
                //     //     Provider.of<GoogleSignInProvider>(context,
                //     //         listen: false);
                //     // provider.googleLogin();
                //     // storeage("astrologer");
                //   },
                //   child: Container(
                //       decoration: BoxDecoration(
                //         color: Color(0xFF03ADC6).withOpacity(0.5),
                //         borderRadius: BorderRadius.only(
                //           bottomLeft: Radius.circular(20),
                //           bottomRight: Radius.circular(20),
                //           topLeft: Radius.circular(20),
                //           topRight: Radius.circular(20),
                //         ),
                //       ),
                //       child: Center(child: Text('Login as Astrologer'))),
                //   style: TextButton.styleFrom(
                //     // fixedSize: Size(300, 55),
                //     primary: Colors.black87,
                //     textStyle: TextStyle(
                //       color: Colors.black,
                //       fontSize: 18,
                //     ),
                //     side: BorderSide(
                //       color: Colors.transparent,
                //       width: 2,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                //   child: TextButton(
                //     child: Text(
                //       'Forgot Password?',
                //       style: TextStyle(fontSize: 16),
                //     ),
                //     style: TextButton.styleFrom(
                //       primary: Colors.black87,
                //     ),
                //     onPressed: () {},
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
