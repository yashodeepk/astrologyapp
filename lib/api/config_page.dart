import 'package:astrologyapp/WelcomePageUtils/WelcomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

String? uid;
final GlobalKey<State> loadingKey = new GlobalKey<State>();

class ConfigurationPage extends StatefulWidget {
  static const routeName = '/';

  const ConfigurationPage({Key? key}) : super(key: key);

  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  bool? isLoggedIn;

  @override
  void initState() {
    var user = Provider.of<User?>(context, listen: false);
    isLoggedIn = user != null;
    //uid = user!.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Container(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(body: isLoggedIn! ? Home() : LoginPageWidget())),
      ),
    );
  }
}
