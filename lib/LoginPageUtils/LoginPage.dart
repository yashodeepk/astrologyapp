import 'dart:ui';

import 'package:astrologyapp/LoginPageUtils/Astrologerinfo.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAccountWidget extends StatefulWidget {
  @override
  _CreateAccountWidgetState createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  User? currentUser;

  // Future<Null> handleSignIn() async {
  //   prefs = await SharedPreferences.getInstance();

  //   isLoading = true;

  //   GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //   if (googleUser != null) {
  //     GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     User? firebaseUser =
  //         (await firebaseAuth.signInWithCredential(credential)).user;

  //     if (firebaseUser != null) {
  //       // Check is already sign up
  //       final QuerySnapshot result = await FirebaseFirestore.instance
  //           .collection('normalusers')
  //           .where('id', isEqualTo: firebaseUser.uid)
  //           .get();
  //       final List<DocumentSnapshot> documents = result.docs;
  //       if (documents.length == 0) {
  //         // Update data to server if new user
  //         FirebaseFirestore.instance
  //             .collection('normalusers')
  //             .doc(firebaseUser.uid)
  //             .set({
  //           'name': firebaseUser.displayName,
  //           'photoUrl': firebaseUser.photoURL,
  //           'id': firebaseUser.uid,
  //           'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
  //           'chattingWith': null
  //         });

  //         // Write data to local
  //         currentUser = firebaseUser;
  //         await prefs?.setString('id', currentUser!.uid);
  //         await prefs?.setString('name', currentUser!.displayName ?? "");
  //         await prefs?.setString('photoUrl', currentUser!.photoURL ?? "");
  //       } else {
  //         DocumentSnapshot documentSnapshot = documents[0];
  //         UserChat userChat = UserChat.fromDocument(documentSnapshot);
  //         // Write data to local
  //         await prefs?.setString('id', userChat.id);
  //         await prefs?.setString('name', userChat.name);
  //         await prefs?.setString('photoUrl', userChat.photoUrl);
  //         await prefs?.setString('aboutMe', userChat.aboutMe);
  //       }
  //       Fluttertoast.showToast(msg: "Sign in success");
  //       isLoading = false;
  //     } else {
  //       Fluttertoast.showToast(msg: "Sign in fail");
  //       isLoading = false;
  //     }
  //     Navigator.pop(context);
  //   } else {
  //     Fluttertoast.showToast(msg: "Can not init google sign in");
  //     isLoading = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text(
              'Login',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: TextButton.icon(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
                Navigator.of(context).pop();
                // storeage("normaluser");
                astrologer = false;
                print('login pressed ...');
              },
              label: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login with Google'),
                  Icon(
                    LineIcons.googlePlus,
                    size: 28,
                    color: Colors.red,
                  )
                ],
              )),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                fixedSize: Size(300, 45),
                primary: Colors.black87,
                textStyle: TextStyle(
                  fontSize: 18,
                ),
                side: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              icon: Icon(
                LineIcons.alternateSignIn,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 25),
            child: TextButton.icon(
              onPressed: () {
                // final provider =
                //     Provider.of<GoogleSignInProvider>(context,
                //         listen: false);
                // provider.googleLogin();
                // storeage("astrologer");
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    // barrierColor: Colors.black,
                    context: context,
                    builder: (context) =>
                        SingleChildScrollView(child: AstrologerinfoWidget()));
              },
              label: Center(child: Text('Login as Astrologer')),
              icon: Icon(
                LineIcons.alternateSignIn,
                color: Colors.black,
              ),
              style: TextButton.styleFrom(
                fixedSize: Size(300, 45),
                primary: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
                side: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          //   child: TextButton(
          //     child: Text(
          //       'Forgot Password?',
          //       style: TextStyle(fontSize: 16),
          //     ),
          //     style: TextButton.styleFrom(
          //       primary: Colors.blue[900],
          //     ),
          //     onPressed: () {},
          //   ),
          // )
        ],
      ),
    );
  }
}
