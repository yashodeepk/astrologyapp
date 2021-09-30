import 'package:astrologyapp/LoginPageUtils/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String RiveFileName = 'assets/Rive/astro.riv';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // backgroundColor: ,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[900],
        // decoration: BoxDecoration(
        //   gradient: gradian.LinearGradient(
        //     colors: [
        //       Color(0xffffffff),
        //       Color(0xfffdb903),
        //     ],
        //     // stops: [0, 1],
        //     begin: Alignment(0.07, -1),
        //     end: Alignment(-0.07, 1),
        //   ),
        // ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                // padding: EdgeInsets.only(top: 50),
                // width: double.infinity,
                // height: double.infinity,
                // decoration: BoxDecoration(
                //   color: Colors.indigo,
                // ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 50, 0, 2),
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Find Your Answers Here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.all(Radius.circular(32)),
                // ),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: RiveAnimation.asset(
                      RiveFileName,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            // barrierColor: Colors.black,
                            context: context,
                            builder: (context) => SingleChildScrollView(
                                  child: CreateAccountWidget(),
                                ));
                        // final provider =
                        //     Provider.of<GoogleSignInProvider>(context, listen: false);
                        // provider.googleLogin();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => CreateAccountWidget()));
                        print('GetStarted pressed ...');
                      },
                      style: TextButton.styleFrom(
                        fixedSize: Size(300, 45),
                        backgroundColor: Colors.blue[900],
                        primary: Colors.white,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
