import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/meetings.dart';
import 'package:astrologyapp/pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MeetingService {
  final firestoreService = FirebaseFirestore.instance;
  static MeetingService? _instance;
  static String? _email;

  MeetingService._();

  static MeetingService get instance {
    if (FirebaseAuth.instance.currentUser != null) {
      _email = FirebaseAuth.instance.currentUser!.email;
    }
    return _instance == null ? _instance = MeetingService._() : _instance!;
  }

  //create meeting
  Future<void> createMeeting(Meetings meetings) async {
    return await firestoreService
        .collection('event')
        .doc(meetings.meetingId)
        .set(meetings.toJson());
  }

  //fetch meetings
  Stream<List<Meetings>> getMeetingByTime() {
    return userType == userX
        ? firestoreService
            .collection(event)
            .orderBy("createdAt", descending: true)
            .where('userEmail', isEqualTo: _email)
            .limit(1)
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((document) => Meetings.fromJson(document.data()))
                .toList(growable: true))
            .handleError((error) {
            print("error --- $error");
          })
        : firestoreService
            .collection(event)
            .orderBy("createdAt", descending: true)
            .where('astrologerEmail', isEqualTo: _email)
            .limit(1)
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((document) => Meetings.fromJson(document.data()))
                .toList(growable: true))
            .handleError((error) {
            print("error --- $error");
          });
  }
}
