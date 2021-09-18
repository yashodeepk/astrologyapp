import 'dart:convert';

Meetings meetingsFromJson(String str) => Meetings.fromJson(json.decode(str));

String meetingsToJson(Meetings data) => json.encode(data.toJson());

class Meetings {
  Meetings(
      {required this.meetingId,
      required this.paymentDescription,
      required this.createdAt,
      required this.meetingLink,
      required this.astrologerName,
      required this.astrologerEmail,
      required this.astrologerId,
      required this.userName,
      required this.userEmail,
      required this.userId,
      required this.timeSelected,
      required this.paymentId,
      required this.attendeeEmails});

  final String meetingId;
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

  factory Meetings.fromJson(Map<String, dynamic> json) => Meetings(
        meetingId: json["meetingId"],
        paymentDescription: json["paymentDescription"],
        createdAt: json["createdAt"],
        meetingLink: json["meetingLink"],
        astrologerName: json["astrologerName"],
        astrologerEmail: json["astrologerEmail"],
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
        "meetingId": meetingId,
        "paymentDescription": paymentDescription,
        "createdAt": createdAt,
        "meetingLink": meetingLink,
        "astrologerName": astrologerName,
        "astrologerEmail": astrologerEmail,
        "astrologerId": astrologerId,
        "userName": userName,
        "userEmail": userEmail,
        "userId": userId,
        "timeSelected": timeSelected,
        "paymentId": paymentId,
        "attendeeEmails": List<dynamic>.from(attendeeEmails.map((x) => x)),
      };
}
