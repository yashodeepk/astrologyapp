import 'package:flutter/material.dart';

class LoginPageWidget extends StatefulWidget {
  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFFFDD00),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment(-0.14, -0.08),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0x00444D59),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                        child: Text(
                          'Welcome',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 430),
                        child: Text(
                          'Find Your Answers Here',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 0, 40, 70),
                        child: TextButton(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          style: TextButton.styleFrom(
                            fixedSize: Size(300, 55),
                            primary: Color(0xFF4C3CB0),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            side: BorderSide(
                              color: Color(0x0003DAC6),
                              width: 1,
                            ),
                          ),
                          child: Text('Login To Continue'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
