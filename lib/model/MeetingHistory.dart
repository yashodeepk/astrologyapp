import 'package:astrologyapp/pages/MeetingHistory_page/MeetingHistory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MeetingHistory {
  static Future checkMeetings(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('event')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((onValue) async {
      if (onValue.exists) {
        Navigator.pushNamed(
          context,
          MeetingHistoryPage.routeName,
        );
      } else {
        Fluttertoast.showToast(msg: 'No Meetings found');
      }
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> read() {
    CollectionReference<Map<String, dynamic>> notesItemCollection =
        FirebaseFirestore.instance
            .collection('event')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('Meetings');

    return notesItemCollection.snapshots();
  }
}
