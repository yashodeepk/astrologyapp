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
                color: Colors.blue[900],
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: TextButton.icon(
              onPressed: () {
                setState(() {});
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);

                provider.googleLogin(false);
                Navigator.of(context).pop();
                print('login as user');
              },
              label: Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login with Google '),
                  Icon(
                    LineIcons.googlePlus,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              )),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0))),
                fixedSize: Size(300, 45),
                primary: Colors.white,
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
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: TextButton.icon(
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin(true);
                Navigator.of(context).pop();
                // showModalBottomSheet(
                //     backgroundColor: Colors.transparent,
                //     isScrollControlled: true,
                //     // barrierColor: Colors.black,
                //     context: context,
                //     builder: (context) =>
                //         SingleChildScrollView(child: AstrologerLoginWidget()));
              },
              label: Center(child: Text('Login as Astrologer')),
              icon: Icon(
                LineIcons.alternateSignIn,
                color: Colors.white,
              ),
              style: TextButton.styleFrom(
                fixedSize: Size(300, 45),
                primary: Colors.white,
                backgroundColor: Colors.blue[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: TextButton(
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
              child: Center(
                  child: Text(
                'New Astrologer? Click Here',
                style: TextStyle(fontStyle: FontStyle.italic),
              )),
              style: TextButton.styleFrom(
                fixedSize: Size(300, 10),
                primary: Colors.blue,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
