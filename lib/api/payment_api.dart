import 'dart:convert';

import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/PaymentInfo.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentApi {
  PaymentApi._();

  static PaymentApi? _instance;
  static String? paymentId;
  static Razorpay? _razorpay;
  PaymentState? paymentState;

  //authorization
  var basicAuth = 'Basic ' +
      base64Encode(utf8.encode('$razorPayUserName:$razorPayPassword'));

  static PaymentApi get instance {
    return _instance == null ? _instance = PaymentApi._() : _instance!;
  }

  void initializeRazorPay() {
    paymentState = PaymentState.INITIAL;
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
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
      paymentId = response.paymentId;
      //  _paymentProvider!.savePaymentId('${response.paymentId}');
      print(
          " success.....................IST?..............................................................................");
      //call api and get response
      await getPaymentInfo(paymentId!);
      /* print(" success...................................................................................................");


      print(
          "${response.orderId} \n${response.paymentId} \n${response.signature}");*/
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    paymentState = PaymentState.FAILURE;
    print("Payment Failed");

    print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
  }

  Future<PaymentInfo> getPaymentInfo(String pid) async {
    final getResponse = await http.get(
      Uri.parse('$razorPayBaseUrl$pid'),
      headers: {
        'authorization': basicAuth,
        'Content-type': 'application/json',
        "accept": 'application/json'
      },
    );

    final response = paymentInfoFromJson(getResponse.body);

    print('re ... ${response.status}');

    return response;
  }
}

enum PaymentState { INITIAL, SUCCESS, FAILURE }
