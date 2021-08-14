// import 'package:astrologyapp/LoginPageUtils/LoginPage.dart';
import 'package:astrologyapp/GoogleMeetUtils/calenderevent.dart';
import 'package:astrologyapp/GoogleMeetUtils/secrate.dart';
import 'package:astrologyapp/WelcomePageUtils/WelcomePage.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:astrologyapp/pages/ChatPage.dart';
import 'package:astrologyapp/pages/ConsultPage.dart';
import 'package:astrologyapp/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:provider/provider.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var _clientID = new ClientId(Secret.getId(), "");
  const _scopes = const [cal.CalendarApi.calendarScope];
  // await clientViaUserConsent(_clientID, _scopes, prompt)
  //     .then((AuthClient client) async {
  //   CalendarClient.calendar = cal.CalendarApi(client);
  // });

  runApp(MyApp());
}

// void prompt(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

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
        // fixedColor: Color(0xff22262B),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
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
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Account',
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
