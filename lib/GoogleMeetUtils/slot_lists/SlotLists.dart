import 'dart:convert';

import 'package:astrologyapp/actions/actions.dart';
import 'package:astrologyapp/actions/dialog.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/main.dart';
import 'package:astrologyapp/model/PaymentInfo.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:astrologyapp/phoneAuthUtils/getphone.dart';
import 'package:astrologyapp/provider/meeting_provider.dart';
import 'package:astrologyapp/provider/slot_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../calenderevent.dart';

class SlotLists extends StatefulWidget {
  final List<String> slotList;
  final Astrologer? astrologer;
  final dayOfWeek;
  final day;

  SlotLists(
      {Key? key,
      required this.slotList,
      required this.astrologer,
      required this.dayOfWeek,
      required this.day})
      : super(key: key);

  @override
  _SlotListsState createState() => _SlotListsState();
}

class _SlotListsState extends State<SlotLists> {
  int? _slotSelected;
  bool isItemSelected = false;
  String _itemSelected = '';
  User? _user;
  SlotProvider _slotProvider = SlotProvider();
  MeetingProvider _meetingProvider = MeetingProvider();
  Razorpay? _razorpay;
  final GlobalKey<State> loadingKey = new GlobalKey<State>();
  CalendarClient calendarClient = CalendarClient();
  List<calendar.EventAttendee> attendeeEmails = [];
  final now = new DateTime.now();

  //authorization
  var basicAuth = 'Basic ' +
      base64Encode(utf8.encode('$razorPayUserName:$razorPayPassword'));

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser!;
    initializeRazorPay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.slotList.isEmpty
        ? Expanded(
            child: Container(
            child: Center(
                child: Text(
              noSlotsAvailableForThisDay,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: twentyDp),
            )),
          ))
        : Expanded(
            child: Scaffold(
            bottomSheet: buildPaymentButton(),
            body: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Wrap(
                          children: widget.slotList.map((f) {
                            return GestureDetector(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                margin: EdgeInsets.only(
                                    left: 5.0,
                                    right: 5.0,
                                    top: 10.0,
                                    bottom: 10.0),
                                decoration: BoxDecoration(
                                  color: _slotSelected ==
                                          widget.slotList.indexOf(f)
                                      ? Colors.blue[900]
                                      : Colors.white,
                                  border: Border.all(
                                      color: Colors.black54, width: 1.3),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          32) //                 <--- border radius here
                                      ),
                                ),
                                child: Text(
                                  f,
                                  style: TextStyle(
                                    color: _slotSelected ==
                                            widget.slotList.indexOf(f)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              onTap: () {
                                isItemSelected = true;
                                _slotSelected = widget.slotList.indexOf(f);
                                _itemSelected = f;
                                setState(() {});
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
  }

  //payment button
  Widget buildPaymentButton() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: sixtyDp, vertical: twentyDp),
      child: MaterialButton(
        onPressed: () {
          _itemSelected.isEmpty
              ? ShowAction().showToast(pleaseSelectSlot, Colors.red)
              : (_user!.phoneNumber != null)
                  ? callPaymentMethod(
                      amountToPay: widget.astrologer!.fees,
                      name: _user!.displayName!,
                      description:
                          'Payment made from User ( ${_user!.displayName!} ) to Astrologer  ( ${widget.astrologer!.name!} )',
                      email: _user!.email!,
                      phoneNumber: _user!.phoneNumber!) //proceed to payment
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => PhoneAuthGetPhone(
                              //Passing astrologer data and callPaymentMethod to phone auth page
                              astrologer: widget.astrologer!,
                              callPaymentMethod: callPaymentMethod)),
                    );
        },
        child: Text(
          proceedToPay,
        ),
        textColor: Colors.white,
        color: Color(0xFF4736B5),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(thirtyDp)),
      ),
    );
  }

  void callPaymentMethod(
      {required int amountToPay,
      required String name,
      required String description,
      required String email,
      required String phoneNumber}) async {
    PgDialog.showLoadingDialog(context, loadingKey, loading, Colors.white);

    //update provider
    _slotProvider.removeBookedSlotFromList(
        widget.dayOfWeek, widget.astrologer!.email, _itemSelected);

    Future.delayed(Duration(seconds: 3)).then((value) =>
        {launchRazorPay(amountToPay, name, description, email, phoneNumber)});
  }

  void launchRazorPay(int amount, String name, String description, String email,
      String phoneNumber) {
    amount = amount * 100;

    var options = {
      'key': rzp_key,
      'amount': "$amount",
      'name': name,
      'description': description,
      'prefill': {'contact': phoneNumber, 'email': email}
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //check for paymentId
    if (response.paymentId != null) {
      await getPaymentInfo('${response.paymentId}');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    ShowAction.showDetails(
        "Payment failed",
        "Error occurred during the payment.Please try again",
        context,
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ShowAction.showDetails(
        "Payment failed",
        "Error occurred during the payment.Please try again",
        context,
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text("OK")));
  }

  Future<void> getPaymentInfo(String pid) async {
    final getResponse = await http.get(
      Uri.parse('$razorPayBaseUrl$pid'),
      headers: {
        'authorization': basicAuth,
        'Content-type': 'application/json',
        "accept": 'application/json'
      },
    );

    final response = paymentInfoFromJson(getResponse.body);
    if (getResponse.body != null) {
      await FirebaseFirestore.instance
          .collection('Payments')
          .doc(_user!.email)
          .collection('DonePayments')
          .doc(response.id)
          .set({
        'paymentId': response.id,
        'description': response.description,
        'amount': response.amount,
        'paidTo': widget.astrologer!.email!,
        'from': _user!.email!,
        'paymentDateTime':
            DateFormat.yMMMMd('en_US').add_jm().format(DateTime.now())
      }).then((value) async {
        //get start and end time
        var splitAndExtractTime =
            _itemSelected.toString().replaceAll(RegExp("[\s-\s]"), '');

        String startTime =
            splitAndExtractTime.toString().split('-')[0].toString();

        String endTime =
            splitAndExtractTime.toString().split('-')[1].toString();

        TimeOfDay startTimeOfDay = ShowAction.stringToTimeOfDay(startTime);
        TimeOfDay endTimeOfDay =
            ShowAction.stringToTimeOfDay(endTime.substring(1));

        var startTimeToMilliseconds, endTimeToMilliseconds;

        if (widget.day == 0) {
          var day = now.day;
          startTimeToMilliseconds = DateTime(now.year, now.month, day,
              startTimeOfDay.hour, startTimeOfDay.minute);
          endTimeToMilliseconds = DateTime(
              now.year, now.month, day, endTimeOfDay.hour, endTimeOfDay.minute);
        } else {
          startTimeToMilliseconds = DateTime(now.year, now.month, widget.day,
              startTimeOfDay.hour, startTimeOfDay.minute);
          endTimeToMilliseconds = DateTime(now.year, now.month, widget.day,
              endTimeOfDay.hour, endTimeOfDay.minute);
        }

        final format = DateFormat('dd/MM/yyyy');

        print(" --- ${format.format(startTimeToMilliseconds)}  ?? $startTime");
        //.remove slot ....
        await _slotProvider.removeSelectedSlot();

        calendar.EventAttendee user = calendar.EventAttendee();
        user.email = _user!.email!;
        attendeeEmails.add(user);
        calendar.EventAttendee astrologer = calendar.EventAttendee();
        astrologer.email = widget.astrologer!.email!;
        attendeeEmails.add(astrologer);
        //create calender event
        await calendarClient
            .insert(
                title:
                    'Meeting with ${_user!.email} and ${widget.astrologer!.email}',
                description: response.description,
                location: 'Online',
                attendeeEmailList: attendeeEmails,
                shouldNotifyAttendees: true,
                hasConferenceSupport: true,
                startTime: startTimeToMilliseconds,
                endTime: endTimeToMilliseconds)
            .then((eventData) async {
          String eventId = eventData['id']!;
          String eventLink = eventData['link']!;

          dynamic emails = [];

          for (int i = 0; i < attendeeEmails.length; i++)
            emails.add(attendeeEmails[i].email!);

          //2.notify meeting data
          _meetingProvider.notifyMeetingDetailsListener(
              response.description,
              now,
              format.format(startTimeToMilliseconds),
              startTime,
              eventLink,
              eventId,
              emails,
              widget.astrologer!.email!,
              widget.astrologer!.name!,
              widget.astrologer!.photoUrl!,
              widget.astrologer!.id!,
              _user!.displayName,
              _user!.email,
              _user!.uid,
              _itemSelected,
              response.id);

          //create meeting
          _meetingProvider.createMeeting();
        }).catchError((e) {
          print(" eerrorrr ${e.toString()}");
        });

        Navigator.of(context).pop();
      }).catchError((onError) {
        print(onError);
      });
    }

    ShowAction.showAlertDialog(
        'Payment successful',
        'Your payment has been captured successfully',
        context,
        SizedBox(),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PageNavigator(
                  selectedIndex: 2,
                ),
              ));
              //
            },
            child: Text(
              ok,
              style: TextStyle(color: CupertinoColors.white),
            )));

    // return response;
  }
}
