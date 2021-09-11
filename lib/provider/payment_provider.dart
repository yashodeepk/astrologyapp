import 'package:astrologyapp/api/payment_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PaymentProvider with ChangeNotifier {
  PaymentApi _paymentApi = PaymentApi.instance;

  PaymentProvider() {
    _paymentApi.initializeRazorPay();
  }

  int? _amount;
  String? _name, _description, _email;

  get getAmount => _amount;

  get getName => _name;

  get getEmail => _email;

  get getDescription => _description;

  savePaymentInfo(int amount, name, description, email) {
    _amount = amount;
    _name = name;
    _description = description;
    _email = email;

    notifyListeners();
  }

  makePayment(BuildContext context) async {
    _paymentApi.launchRazorPay(getAmount, getName, getDescription, getEmail);

    await checkPayment(context);
  }

  checkPayment(BuildContext context) async {
    if (_paymentApi.paymentState == PaymentState.SUCCESS) {
      print('got it');
    }
    notifyListeners();
  }
}
