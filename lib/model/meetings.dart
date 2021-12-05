import 'dart:convert';

Meetings meetingsFromJson(String str) => Meetings.fromJson(json.decode(str));

String meetingsToJson(Meetings data) => json.encode(data.toJson());

class Meetings {
  Meetings(
      {required this.scheduledDate,
      required this.scheduledTime,
      required this.paymentDescription,
      required this.createdAt,
      required this.meetingLink,
      required this.astrologerName,
      required this.astrologerEmail,
      required this.astrologerPhoto,
      required this.astrologerId,
      required this.userName,
      required this.userEmail,
      required this.userId,
      required this.timeSelected,
      required this.paymentId,
      required this.attendeeEmails});

  final String paymentDescription;
  final createdAt;
  final List<dynamic> attendeeEmails;
  final String meetingLink;
  final String astrologerName;
  final String astrologerEmail;
  final String astrologerId;
  final String userName;
  final String userEmail;
  final String userId;
  final String timeSelected;
  final String paymentId;
  final String scheduledDate;
  final String scheduledTime;
  final String astrologerPhoto;

  factory Meetings.fromJson(Map<String, dynamic> json) => Meetings(
        scheduledDate: json["scheduledDate"],
        scheduledTime: json["scheduledTime"],
        paymentDescription: json["paymentDescription"],
        createdAt: json["createdAt"],
        meetingLink: json["meetingLink"],
        astrologerName: json["astrologerName"],
        astrologerEmail: json["astrologerEmail"],
        astrologerPhoto: json["astrologerPhoto"],
        astrologerId: json["astrologerId"],
        userName: json["userName"],
        userEmail: json["userEmail"],
        userId: json["userId"],
        timeSelected: json["timeSelected"],
        paymentId: json["paymentId"],
        attendeeEmails:
            List<dynamic>.from(json["attendeeEmails"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "scheduledDate": scheduledDate,
        "scheduledTime": scheduledTime,
        "paymentDescription": paymentDescription,
        "createdAt": createdAt,
        "meetingLink": meetingLink,
        "astrologerName": astrologerName,
        "astrologerEmail": astrologerEmail,
        "astrologerPhoto": astrologerPhoto,
        "astrologerId": astrologerId,
        "userName": userName,
        "userEmail": userEmail,
        "userId": userId,
        "timeSelected": timeSelected,
        "paymentId": paymentId,
        "attendeeEmails": List<dynamic>.from(attendeeEmails.map((x) => x)),
      };
}
