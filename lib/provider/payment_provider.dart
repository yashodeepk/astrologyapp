import 'package:astrologyapp/api/payment_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PaymentProvider with ChangeNotifier {
  PaymentApi _paymentApi = PaymentApi.instance;

  PaymentProvider() {
    _paymentApi.initializeRazorPay();
  }

  int? _amount;
  String? _name, _description, _email, _phoneNumber;

  get getAmount => _amount;

  get getName => _name;

  get getEmail => _email;

  get getDescription => _description;

  get getPhoneNumber => _phoneNumber;

  savePaymentInfo(int amount, name, description, email, phoneNumber) {
    _amount = amount;
    _name = name;
    _description = description;
    _email = email;
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  makePayment(BuildContext context) async {
    _paymentApi.launchRazorPay(
        getAmount, getName, getDescription, getEmail, getPhoneNumber);

    await checkPayment(context);
  }

  checkPayment(BuildContext context) async {
    if (_paymentApi.paymentState == PaymentState.SUCCESS) {
      print('got it');
    }
    notifyListeners();
  }
}
