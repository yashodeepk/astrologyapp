import 'package:astrologyapp/model/meetings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingService {
  final firestoreService = FirebaseFirestore.instance;
  static MeetingService? _instance;

  MeetingService._();

  static MeetingService get instance {
    return _instance == null ? _instance = MeetingService._() : _instance!;
  }

  //create meeting
  Future<void> createMeeting(Meetings meetings) async {
    return await firestoreService
        .collection('event')
        .doc(meetings.meetingId)
        .set(meetings.toJson());
  }
}
