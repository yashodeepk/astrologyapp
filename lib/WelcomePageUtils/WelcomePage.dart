import 'package:astrologyapp/LoginPageUtils/LoginPage.dart';
import 'package:astrologyapp/api/signinapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:flutter/src/painting/gradient.dart' as gradian;

class LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool get isPlaying => _controller.isActive;

  bool button = false;
  final bikeRiveFileName = 'assets/astro.riv';
  Artboard? _bikeArtboard;
  late StateMachineController _controller;
  SMIInput<bool>? _pressInput;

  @override
  void initState() {
    super.initState();
    _bikeRiveFile();
  }

  void _bikeRiveFile() async {
    final bytes = await rootBundle.load(bikeRiveFileName);
    final file = RiveFile.import(bytes);

    final artboard = file.mainArtboard;
    var controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');
    if (controller != null) {
      artboard.addController(controller);
      _pressInput = controller.findInput('pressed');
    } else {
      return;
    }
    setState(() {
      _bikeArtboard = artboard;
      _pressInput?.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: ,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: gradian.LinearGradient(
            colors: [
              Color(0xff0c164f),
              Color(0xff5643fd),
              // Color(0xffba1e68),
            ],
            // stops: [0, 1],
            begin: Alignment(0.07, -1),
            end: Alignment(-0.07, 1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              // width: double.infinity,
              // height: double.infinity,
              // decoration: BoxDecoration(
              //   color: Colors.indigo,
              // ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Find Your Answers Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              // decoration: BoxDecoration(
              //   color: Colors.white,
              //   borderRadius: BorderRadius.all(Radius.circular(32)),
              // ),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 400,
                  child: _bikeArtboard == null
                      ? const SizedBox(
                          child: Center(
                            child: Text(""),
                          ),
                        )
                      : Rive(
                          fit: BoxFit.fitWidth,
                          artboard: _bikeArtboard!,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: TextButton(
                onPressed: () async {
                  // final provider =
                  //     Provider.of<GoogleSignInProvider>(context, listen: false);
                  // provider.googleLogin();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateAccountWidget()));

                  print('Button pressed ...');
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(300, 45),
                  backgroundColor: Colors.black.withOpacity(0.7),
                  primary: Colors.white,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  side: BorderSide(
                    color: Colors.amber,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: Text('Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
