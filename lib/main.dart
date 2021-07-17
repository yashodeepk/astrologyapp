import 'package:astrologyapp/LoginPageUtils/LoginPage.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:astrologyapp/pages/ChatPage.dart';
import 'package:astrologyapp/pages/ConsultPage.dart';
import 'package:astrologyapp/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
                return Navigator();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Oops!!, Something went wrong"),
                );
              } else {
                return CreateAccountWidget();
              }
            }),
      );
}

class Navigator extends StatefulWidget {
  const Navigator({Key? key}) : super(key: key);

  @override
  _NavigatorState createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  int selectedPage = 0;

  final _pageOptions = [
    HomePageWidget(),
    ConsultWidget(),
    ChatWidget(),
    AccountPageWidget()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pageOptions[selectedPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF03ADC6),
        unselectedItemColor: Colors.grey[700],
        elevation: 0,
        //fixedColor: Color(0xff22262B),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Horoscope',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2_fill),
            label: 'Consult',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
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
