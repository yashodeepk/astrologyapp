import 'package:astrologyapp/pages/PaymentHistory_page/PaymentHistoryPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PaymentHistory {
  static Future checkPayment(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('Payments')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((onValue) async {
      if (onValue.exists) {
        Navigator.pushNamed(
          context,
          PaymentHistoryPage.routeName,
        );
      } else {
        Fluttertoast.showToast(msg: 'No Payments Done');
      }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> readPayments() {
    CollectionReference<Map<String, dynamic>> notesItemCollection =
        FirebaseFirestore.instance
            .collection('Payments')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('DonePayments');

    return notesItemCollection.snapshots();
  }
}
