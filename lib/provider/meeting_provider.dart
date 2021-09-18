import 'package:astrologyapp/model/meetings.dart';
import 'package:astrologyapp/service/meeting_service.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class MeetingProvider with ChangeNotifier {
  String? _meetingId;
  String? _paymentDescription;
  dynamic _createdAt;
  String? _meetingLink;
  String? _astrologerName;
  String? _astrologerEmail;
  String? _astrologerId;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _timeSelected;
  String? _paymentId;
  dynamic _emailList;
  var _uuid = Uuid();

  //notify listener
  notifyMeetingDetailsListener(
      paymentDes,
      createdAt,
      meetingLink,
      meetingId,
      emailList,
      astrologerEmail,
      astrologerName,
      astrologerId,
      userName,
      userEmail,
      userId,
      slotTime,
      paymentId) {
    _paymentDescription = paymentDes;
    _createdAt = createdAt;
    _meetingLink = meetingLink;
    _meetingId = meetingId;
    _emailList = emailList;
    _astrologerEmail = astrologerEmail;
    _astrologerName = astrologerName;
    _astrologerId = astrologerId;
    _userName = userName;
    _userEmail = userEmail;
    _userId = userId;
    _timeSelected = slotTime;
    _paymentId = paymentId;

    notifyListeners();
  }

  //create new meeting
  createMeeting() async {
    Meetings meetings = Meetings(
        meetingId: meetingId,
        attendeeEmails: getEmailList,
        paymentDescription: paymentDescription,
        createdAt: createdAt,
        meetingLink: meetingLink,
        astrologerName: astrologerName,
        astrologerEmail: astrologerEmail,
        astrologerId: astrologerId,
        userName: userName,
        userEmail: userEmail,
        userId: userId,
        timeSelected: timeSelected,
        paymentId: paymentId);
    await MeetingService.instance.createMeeting(meetings);
  }

  get paymentDescription => _paymentDescription;

  get createdAt => _createdAt;

  get getEmailList => _emailList;

  get meetingLink => _meetingLink;

  get meetingId => _meetingId;

  get astrologerName => _astrologerName;

  get astrologerEmail => _astrologerEmail;

  get astrologerId => _astrologerId;

  get userName => _userName;

  get userEmail => _userEmail;

  get userId => _userId;

  get timeSelected => _timeSelected;

  get paymentId => _paymentId;
}
