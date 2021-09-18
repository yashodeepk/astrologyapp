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
  Astrologer({@required this.name,
    @required this.id,
    @required this.email,
    @required this.experience,
    @required this.expertise,
    @required this.phoneNumber,
    @required this.fees,
    @required this.photoUrl,
    @required this.rating});

  String? id;
  final name;
  final email;
  final experience;
  final expertise;
  final phoneNumber;
  final fees;
  final photoUrl;
  final rating;

  factory Astrologer.fromJson(Map<String, dynamic> json) =>
      Astrologer(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        experience: json["experience"],
        expertise: json["expertise"],
        phoneNumber: json["phoneNumber"],
        fees: json["fees"],
        photoUrl: json["photoUrl"],
        rating: json["rating"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        'id': id,
        "email": email,
        "experience": experience,
        "expertise": expertise,
        "phoneNumber": phoneNumber,
        "fees": fees,
        "photoUrl": photoUrl,
        "rating": rating,
      };
}
