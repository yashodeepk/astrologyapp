// To parse this JSON data, do
//
//     final astrologer = astrologerFromJson(jsonString);

import 'dart:convert';

import 'package:meta/meta.dart';

class Users {}

Astrologer astrologerFromJson(String str) =>
    Astrologer.fromJson(json.decode(str));

String astrologerToJson(Astrologer data) => json.encode(data.toJson());

class Astrologer {
  Astrologer({
    @required this.name,
    @required this.email,
    @required this.experience,
    @required this.expertise,
    @required this.phoneNumber,
    @required this.fees,
  });

  final name;
  final email;
  final experience;
  final expertise;
  final phoneNumber;
  final fees;

  factory Astrologer.fromJson(Map<String, dynamic> json) => Astrologer(
        name: json["name"],
        email: json["email"],
        experience: json["experience"],
        expertise: json["expertise"],
        phoneNumber: json["phoneNumber"],
        fees: json["fees"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "experience": experience,
        "expertise": expertise,
        "phoneNumber": phoneNumber,
        "fees": fees,
      };
}
