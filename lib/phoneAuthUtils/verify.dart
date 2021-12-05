import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astrologyapp/provider/phone_auth.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rv;

class PhoneAuthVerify extends StatefulWidget {
  /*
   *  cardBackgroundColor & logo values will be passed to the constructor
   *  here we access these params in the _PhoneAuthState using "widget"
   */
  final Color cardBackgroundColor = Color(0xFFFCA967);
  final String logo = firebase;
  final String appName = "Astrology app";
  //Passing Astrologer data
  final Astrologer? astrologer;
  //function from slot page
  final dynamic callPaymentMethod;
  PhoneAuthVerify(
      {Key? key, required this.astrologer, required this.callPaymentMethod})
      : super(key: key);
  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  double? _height, _width, _fixedPadding;

  User? _user;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";
  @override
  void initState() {
    super.initState();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-verify-phone");

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.025;

    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);

    phoneAuthDataProvider.setMethods(
      onStarted: onStarted,
      onError: onError,
      onFailed: onFailed,
      onVerified: onVerified,
      onCodeResent: onCodeResent,
      onCodeSent: onCodeSent,
      onAutoRetrievalTimeout: onAutoRetrievalTimeOut,
    );

    /*
     *  Scaffold: Using a Scaffold widget as parent
     *  SafeArea: As a precaution - wrapping all child descendants in SafeArea, so that even notched phones won't loose data
     *  Center: As we are just having Card widget - making it to stay in Center would really look good
     *  SingleChildScrollView: There can be chances arising where
     */
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: scaffoldKey,
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Center(
        child: SingleChildScrollView(
          child: _getBody(),
        ),
      ),
    );
  }

  /*
   *  Widget hierarchy ->
   *    Scaffold -> SafeArea -> Center -> SingleChildScrollView -> Card()
   *    Card -> FutureBuilder -> Column()
   */
  Widget _getBody() => Container(
        decoration: BoxDecoration(
          // color: Colors.blue[900],
          boxShadow: [
            BoxShadow(
              color: GradientTemplate.gradientTemplate[0].colors.last
                  .withOpacity(0.5),
              blurRadius: 8,
              spreadRadius: 2.5,
              offset: Offset(3, 3),
            ),
          ],
          gradient: LinearGradient(
            colors: GradientTemplate.gradientTemplate[0].colors,
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        // color: widget.cardBackgroundColor,
        // elevation: 2.0,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Center(
          child: SizedBox(
            height: _height!,
            width: _width!,
            child: _getColumnBody(),
          ),
        ),
      );

  Widget _getColumnBody() => Column(
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Padding(
              padding: EdgeInsets.all(_fixedPadding!),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.width * 0.7,
                child: rv.RiveAnimation.asset(
                  'assets/Rive/otp.riv',
                  placeHolder: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                  fit: BoxFit.cover,
                ),
              )),

          // AppName:
          Text(widget.appName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700)),

          SizedBox(height: 20.0),

          //  Info text
          Row(
            children: <Widget>[
              SizedBox(width: 16.0),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'Please enter the ',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: 'One Time Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                        text: ' sent to your mobile',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),

          SizedBox(height: 16.0),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              SizedBox(width: 5.0),
            ],
          ),

          SizedBox(height: 32.0),

          RaisedButton(
            elevation: 16.0,
            onPressed: signIn,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'VERIFY',
                style: TextStyle(color: Colors.blue.shade900, fontSize: 18.0),
              ),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          )
        ],
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
      duration: Duration(seconds: 2),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  signIn() {
    if (code.length != 6) {
      _showSnackBar("Invalid OTP");
    }
    Provider.of<PhoneAuthDataProvider>(context, listen: false)
        .verifyOTPAndLogin(smsCode: code);
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String? key, FocusNode? focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key!),
          expands: false,
//          autofocus: key.contains("1") ? true : false,
          autofocus: false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Colors.white,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.w600, color: Colors.white),
//          decoration: InputDecoration(
//              contentPadding: const EdgeInsets.only(
//                  bottom: 10.0, top: 10.0, left: 4.0, right: 4.0),
//              focusedBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide:
//                      BorderSide(color: Colors.blueAccent, width: 2.25)),
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(5.0),
//                  borderSide: BorderSide(color: Colors.white))),
        ),
      );

  onStarted() {
    _showSnackBar("PhoneAuth started");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeSent() {
    _showSnackBar("OTP sent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onCodeResent() {
    _showSnackBar("OTP resent");
//    _showSnackBar(phoneAuthDataProvider.message);
  }

  onVerified() async {
    _showSnackBar(
        "${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
    await Future.delayed(Duration(seconds: 1));
    Navigator.pop(context, true);
    _user = FirebaseAuth.instance.currentUser!;
    //Function call from slot page
    widget.callPaymentMethod(
        amountToPay: widget.astrologer!.fees,
        name: _user!.displayName!,
        description:
            'Payment made from User ( ${_user!.displayName!} ) to Astrologer  ( ${widget.astrologer!.name!} )',
        email: _user!.email!,
        phoneNumber: _user!.phoneNumber!);
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (BuildContext context) => PageNavigator()));
  }

  onFailed() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar("PhoneAuth failed");
  }

  onError() {
//    _showSnackBar(phoneAuthDataProvider.message);
    _showSnackBar(
        "PhoneAuth error ${Provider.of<PhoneAuthDataProvider>(context, listen: false).message}");
  }

  onAutoRetrievalTimeOut() {
    _showSnackBar("PhoneAuth autoretrieval timeout");
//    _showSnackBar(phoneAuthDataProvider.message);
  }
}
