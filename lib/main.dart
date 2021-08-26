// import 'package:astrologyapp/LoginPageUtils/LoginPage.dart';
import 'package:astrologyapp/ChatUtils/userchat.dart';
import 'package:astrologyapp/LoginPageUtils/Astrologerinfo.dart';
import 'package:astrologyapp/WelcomePageUtils/WelcomePage.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:astrologyapp/pages/ChatPage.dart';
import 'package:astrologyapp/pages/ConsultPage.dart';
import 'package:astrologyapp/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          home: Home(),
          theme: ThemeData.light(),
          debugShowCheckedModeBanner: false,
        ),
      );
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                return PageNavigator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Oops!!, Something went wrong"),
                );
              } else {
                return LoginPageWidget();
              }
            }),
      );
}

class PageNavigator extends StatefulWidget {
  const PageNavigator({Key? key}) : super(key: key);

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  int selectedPage = 0;

  final _pageOptions = [HomePageWidget(), ConsultWidget(), ChatWidget()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pageOptions[selectedPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey[700],
        elevation: 0,
        // fixedColor: Color(0xff22262B),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: 'Horoscope',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_2_fill),
              label: 'Consult',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
              label: 'Chat',
              backgroundColor: Colors.white),
        ],
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
