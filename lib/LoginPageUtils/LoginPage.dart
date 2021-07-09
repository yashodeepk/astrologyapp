import 'package:flutter/material.dart';

class CreateAccountWidget extends StatefulWidget {
  @override
  _CreateAccountWidgetState createState() => _CreateAccountWidgetState();
}

class _CreateAccountWidgetState extends State<CreateAccountWidget> {
  TextEditingController? textController1;
  TextEditingController? textController2;
  bool passwordVisibility = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    passwordVisibility = false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Scaffold(
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
                    color: Color(0xFFFFDD00),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                          child: Text(
                            'Login Page',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0x00FFFFFF),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Align(
                              alignment: Alignment(0, 0),
                              child: TextFormField(
                                controller: textController1,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF03DAC6),
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF03DAC6),
                                      width: 2,
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.login,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                ),
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'please enter the Username';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0x00EEEEEE),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Align(
                              alignment: Alignment(0, 0),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 1),
                                child: TextFormField(
                                  controller: textController2,
                                  obscureText: !passwordVisibility!,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF03DAC6),
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xFF03DAC6),
                                        width: 2,
                                      ),
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline_sharp,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () => setState(
                                        () => passwordVisibility =
                                            !passwordVisibility!,
                                      ),
                                      child: Icon(
                                        passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: TextButton(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            child: Center(child: Text('Login')),
                            style: TextButton.styleFrom(
                              fixedSize: Size(300, 55),
                              primary: Color(0xFF4C3CB0),
                              textStyle: TextStyle(
                                color: Color(0xFFFAFAFA),
                                fontSize: 18,
                              ),
                              side: BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: TextButton(
                            onPressed: () {
                              print('Button pressed ...');
                            },
                            child: Center(child: Text('Create Account')),
                            style: TextButton.styleFrom(
                              fixedSize: Size(300, 55),
                              primary: Color(0xFF4C3CB0),
                              textStyle: TextStyle(
                                color: Color(0xFFFAFAFA),
                                fontSize: 18,
                              ),
                              side: BorderSide(
                                color: Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 160),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF160972),
                              fontSize: 22,
                            ),
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
      ),
    );
  }
}
