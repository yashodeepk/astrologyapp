import 'dart:ui';

import 'package:astrologyapp/api/signinapi.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AstrologerinfoWidget extends StatefulWidget {
  @override
  _AstrologerinfoWidgetState createState() => _AstrologerinfoWidgetState();
}

class _AstrologerinfoWidgetState extends State<AstrologerinfoWidget> {
  TextEditingController nametextController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  SharedPreferences? prefs;

  bool isLoading = false;
  User? currentUser;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> addItem({
    required String name,
    required String phonenumber,
    required String email,
    required String experience,
  }) async {
    CollectionReference _mainCollection =
        _firestore.collection('temp_astrologer');
    DocumentReference documentReferencer =
        _mainCollection.doc(emailController.text);

    Map<String, dynamic> data = <String, dynamic>{
      "Name": name,
      "phonenumber": phonenumber,
      "email": email,
      "experience": experience,
    };

    await documentReferencer
        .set(data)
        .whenComplete(
          () => showDialog(
            context: context,
            builder: (BuildContext context) {
              isLoading = false;
              return register(context);
            },
          ),
        )
        .onError(
          (error, stackTrace) => showDialog(
            context: context,
            builder: (BuildContext context) {
              isLoading = true;
              return registerfail(context);
            },
          ),
        );
  }

  AlertDialog register(context) => AlertDialog(
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Center(
            child: Text(
          "Regstration Successfull.",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          textAlign: TextAlign.center,
        )),
        content: Container(
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset('assets/images/space.png'),
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Text(
                "Thank you for Regstration.",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Text(
                'We will get in contact with you within next 7 days.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  child: Text("OK", style: TextStyle(color: Color(0xff03adc6))),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ],
      );
  AlertDialog registerfail(context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Center(
            child: Text(
          "Regstration Fail.",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        )),
        content: Container(
          height: 300,
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/1.png'),
                radius: 75,
              ),
              SizedBox(
                height: 12,
              ),
              // Text(
              //   "Thank you for Regstration.",
              //   textAlign: TextAlign.center,
              // ),
              Text('Oops something went wrong, Please try again..')
            ],
          ),
        ),
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    child:
                        Text("OK", style: TextStyle(color: Color(0xff03adc6))),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    'Please fill all details',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: TextFormField(
                    controller: nametextController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(25),
                    ],
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'please enter the Full Name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phonenumberController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Contact number',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        LineIcons.mobilePhone,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter the Contact number';
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Gmail',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        LineIcons.googlePlusG,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    validator: (val) =>
                        val!.isEmpty || !val.contains("@gmail.com")
                            ? "enter a valid gmail"
                            : null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  // padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: experienceController,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Experience in years',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue.shade900,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4.0),
                          topRight: Radius.circular(4.0),
                        ),
                      ),
                      prefixIcon: Icon(
                        LineIcons.clock,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'please enter the Experience in years';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : TextButton.icon(
                          onPressed: () {
                            // setState(() {
                            //   astrologer = true;
                            // });
                            if (formKey.currentState!.validate()) {
                              // final provider = Provider.of<GoogleSignInProvider>(
                              //     context,
                              //     listen: false);
                              // provider.googleLogin();
                              addItem(
                                  name: nametextController.text,
                                  phonenumber: phonenumberController.text,
                                  email: emailController.text,
                                  experience: experienceController.text);

                              // storeage("normaluser");
                              setState(() {
                                isLoading = true;
                              });

                              // storeage("normaluser");
                              print('Register as astraloger');
                            }
                          },
                          label: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0))),
                            fixedSize: Size(300, 45),
                            primary: Colors.black87,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
