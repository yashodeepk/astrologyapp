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
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences? prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  final currentUser = FirebaseAuth.instance.currentUser;
  void handleSignInuser() async {
    prefs = await SharedPreferences.getInstance();

    isLoading = true;

    if (currentUser != null) {
      print('user');
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: currentUser!.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        print('user created');
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .set({
          'name': currentUser!.displayName,
          'photoUrl': currentUser!.photoURL,
          'id': currentUser!.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
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
  }

  void handleSignInAstroloer() async {
    prefs = await SharedPreferences.getInstance();

    isLoading = true;

    // if (googleUser != null) {

    if (currentUser != null) {
      print('astrologer');
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('astrologers')
          .where('id', isEqualTo: currentUser!.uid)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        print('astro user created');
        // Update data to server if new user
        FirebaseFirestore.instance
            .collection('astrologers')
            .doc(currentUser!.uid)
            .set({
          'name': currentUser!.displayName,
          'photoUrl': currentUser!.photoURL,
          'id': currentUser!.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'about': experienceController,
          'chattingWith': null
        });

        // Write data to local
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
        await prefs?.setString('about', userChat.aboutMe);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      isLoading = false;
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      isLoading = false;
    }
    // } else {
    //   Fluttertoast.showToast(msg: "Can not init google sign in");
    //   isLoading = false;
    // }
  }

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
                if (astrologer) {
                  handleSignInAstroloer();
                } else {
                  handleSignInuser();
                }
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
    ChatWidget()
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
