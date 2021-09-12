import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentApi {
  PaymentApi._();

  static PaymentApi? _instance;
  static Razorpay? _razorpay;
  PaymentState paymentState = PaymentState.INITIAL;

  static PaymentApi get instance {
    return _instance == null ? _instance = PaymentApi._() : _instance!;
  }

  void initializeRazorPay() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void launchRazorPay(int amount, String name, String description, String email,
      String phoneNumber) {
    amount = amount * 100;

    var options = {
      'key': 'rzp_test_F4IrIZIbK0GW0Y',
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (response.orderId != null) {
      paymentState = PaymentState.SUCCESS;
      print(" success");
      print(
          "${response.orderId} \n${response.paymentId} \n${response.signature}");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentState = PaymentState.FAILURE;
    print("Payment Failed");

    print("${response.code}\n${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
  }
}

enum PaymentState { INITIAL, SUCCESS, FAILURE }
