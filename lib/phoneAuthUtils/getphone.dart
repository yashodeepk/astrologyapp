import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:astrologyapp/phoneAuthUtils/selectCountry.dart';
import 'package:astrologyapp/phoneAuthUtils/verify.dart';
import 'package:astrologyapp/provider/countries.dart';
import 'package:astrologyapp/provider/phone_auth.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:provider/provider.dart';

import 'package:astrologyapp/phoneAuthUtils/widget.dart';

class PhoneAuthGetPhone extends StatefulWidget {
  /*
   *  cardBackgroundColor & logo values will be passed to the constructor
   *  here we access these params in the _PhoneAuthState using "widget"
   */
  final Color cardBackgroundColor = Color(0xFF6874C2);
  final String logo = firebase;
  final String appName = "Astrology app";
  //Passing astrologer data
  final Astrologer? astrologer;
  //Passing callPaymentMethod
  final dynamic callPaymentMethod;
  PhoneAuthGetPhone(
      {Key? key, required this.astrologer, required this.callPaymentMethod})
      : super(key: key);

  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthGetPhone> {
  /*
   *  _height & _width:
   *    will be calculated from the MediaQuery of widget's context
   *  countries:
   *    will be a list of Country model, Country model contains name, dialCode, flag and code for various countries
   *    and below params are all related to StreamBuilder
   */
  double? _height, _width, _fixedPadding;

  /*
   *  _searchCountryController - This will be used as a controller for listening to the changes what the user is entering
   *  and it's listener will take care of the rest
   */

  /*
   *  This will be the index, we will modify each time the user selects a new country from the dropdown list(dialog),
   *  As a default case, we are using India as default country, index = 31
   */
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final scaffoldKey =
      GlobalKey<ScaffoldState>(debugLabel: "scaffold-get-phone");

  @override
  Widget build(BuildContext context) {
    //  Fetching height & width parameters from the MediaQuery
    //  _logoPadding will be a constant, scaling it according to device's size
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height! * 0.025;
    final countriesProvider = Provider.of<CountryProvider>(context);
    final loader = Provider.of<PhoneAuthDataProvider>(context).loading;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: <Widget>[
          loader
              ? CircularProgressIndicator()
              : Center(
                  child: SingleChildScrollView(
                    child: _getBody(countriesProvider),
                  ),
                ),
        ],
      ),
    );
  }

  /*
   *  Widget hierarchy ->
   *    Scaffold -> SafeArea -> Center -> SingleChildScrollView -> Card()
   *    Card -> FutureBuilder -> Column()
   */
  Widget _getBody(CountryProvider countriesProvider) => Container(
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
            begin: Alignment.bottomCenter,
            end: Alignment.topRight,
          ),
        ),
        // color: widget.cardBackgroundColor,
        // elevation: 2.0,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: SizedBox(
          height: _height!,
          width: _width!,

          /*
       * Fetching countries data from JSON file and storing them in a List of Country model:
       * ref:- List<Country> countries
       * Until the data is fetched, there will be CircularProgressIndicator showing, describing something is on it's way
       * (Previously there was a FutureBuilder rather that the below thing, which created unexpected exceptions and had to be removed)
       */
          child: countriesProvider.countries.length > 0
              ? _getColumnBody(countriesProvider)
              : Center(child: CircularProgressIndicator()),
        ),
      );

  Widget _getColumnBody(CountryProvider countriesProvider) =>
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
            Padding(
              padding: EdgeInsets.fromLTRB(_fixedPadding!, _fixedPadding! + 20,
                  _fixedPadding!, _fixedPadding!),
              child: PhoneAuthWidgets.getLogo(
                  logoPath: widget.logo, height: _height! * 0.2),
            ),

            // AppName:
            Text(widget.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Verify, Your mobile number before making payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: _fixedPadding!, left: _fixedPadding!),
              child: SubTitle(text: 'Select your country'),
            ),

            /*
             *  Select your country, this will be a custom DropDown menu, rather than just as a dropDown
             *  onTap of this, will show a Dialog asking the user to select country they reside,
             *  according to their selection, prefix will change in the PhoneNumber TextFormField
             */
            Padding(
                padding: EdgeInsets.only(
                    left: _fixedPadding!, right: _fixedPadding!),
                child: ShowSelectedCountry(
                  country: countriesProvider.selectedCountry,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SelectCountry()),
                    );
                  },
                )),

            //  Subtitle for Enter your phone
            Padding(
              padding: EdgeInsets.only(top: 10.0, left: _fixedPadding!),
              child: SubTitle(text: 'Enter your phone'),
            ),
            //  PhoneNumber TextFormFields
            Padding(
              padding: EdgeInsets.only(
                  left: _fixedPadding!,
                  right: _fixedPadding!,
                  bottom: _fixedPadding!),
              child: PhoneNumberField(
                controller:
                    Provider.of<PhoneAuthDataProvider>(context, listen: false)
                        .phoneNumberController,
                prefix: countriesProvider.selectedCountry.dialCode ?? "+91",
              ),
            ),

            /*
             *  Some informative text
             */
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(width: _fixedPadding),
                Icon(Icons.info, color: Colors.white, size: 20.0),
                SizedBox(width: 10.0),
                Expanded(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'We will send ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                    TextSpan(
                        text: 'One Time Password',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700)),
                    TextSpan(
                        text: ' to this mobile number',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                  ])),
                ),
                SizedBox(width: _fixedPadding),
              ],
            ),

            /*
             *  Button: OnTap of this, it appends the dial code and the phone number entered by the user to send OTP,
             *  knowing once the OTP has been sent to the user - the user will be navigated to a new Screen,
             *  where is asked to enter the OTP he has received on his mobile (or) wait for the system to automatically detect the OTP
             */
            SizedBox(height: _fixedPadding! * 1.5),
            RaisedButton(
              elevation: 16.0,
              onPressed: startPhoneAuth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'SEND OTP',
                  style: TextStyle(
                      color: widget.cardBackgroundColor, fontSize: 18.0),
                ),
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
            ),
          ],
        ),
      );

  _showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text('$text'),
    );
//    if (mounted) Scaffold.of(context).showSnackBar(snackBar);
    scaffoldKey.currentState!.showSnackBar(snackBar);
  }

  startPhoneAuth() async {
    final phoneAuthDataProvider =
        Provider.of<PhoneAuthDataProvider>(context, listen: false);
    phoneAuthDataProvider.loading = true;
    var countryProvider = Provider.of<CountryProvider>(context, listen: false);
    bool validPhone = await phoneAuthDataProvider.instantiate(
        dialCode: countryProvider.selectedCountry.dialCode,
        onCodeSent: () async {
          Navigator.of(context).pushReplacement(CupertinoPageRoute(
              //passing astrologer and callPaymentMethod to the verification page
              builder: (BuildContext context) => PhoneAuthVerify(
                  astrologer: widget.astrologer!,
                  callPaymentMethod: widget.callPaymentMethod)));
        },
        onFailed: () {
          _showSnackBar(phoneAuthDataProvider.message);
        },
        onError: () {
          _showSnackBar(phoneAuthDataProvider.message);
        });
    if (!validPhone) {
      phoneAuthDataProvider.loading = false;
      _showSnackBar("Oops! Number seems invaild");
      return;
    }
  }
}
