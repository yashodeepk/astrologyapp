import 'dart:convert';

Slots slotsFromJson(String str) => Slots.fromJson(json.decode(str));

String slotsToJson(Slots data) => json.encode(data.toJson());

class Slots {
  Slots({
    this.id,
    this.day,
    this.date,
    this.startAt,
    this.endAt,
    this.order,
    required this.slots,
  });

  final id;
  final day;
  final date;
  final startAt;
  final endAt;
  final order;
  List<dynamic> slots;

  factory Slots.fromJson(Map<String, dynamic> json) => Slots(
        id: json["id"],
        day: json["day"],
        date: json["date"],
        startAt: json["startAt"],
        endAt: json["endAt"],
        order: json["order"],
        slots: List<dynamic>.from(json["slots"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "date": date,
        "startAt": startAt,
        "endAt": endAt,
        "order": order,
        "slots": List<dynamic>.from(slots.map((x) => x)),
      };
}
