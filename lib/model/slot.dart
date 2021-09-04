import 'dart:convert';

Slots slotsFromJson(String str) => Slots.fromJson(json.decode(str));

String slotsToJson(Slots data) => json.encode(data.toJson());

class Slots {
  Slots({
    this.id,
    this.day,
    this.date,
    this.order,
    this.slotList,
    this.slotTimes,
  });

  String? id;
  String? day;
  String? date;
  int? order;
  List<dynamic>? slotList;
  List<dynamic>? slotTimes;

  factory Slots.fromJson(Map<String, dynamic> json) => Slots(
        id: json["id"],
        day: json["day"],
        date: json["date"],
        order: json["order"],
        slotList: List<dynamic>.from(json["slotList"].map((x) => x)),
        slotTimes: List<dynamic>.from(json["slotTimes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "day": day,
        "date": date,
        "order": order,
        "slotList": List<dynamic>.from(slotList!.map((x) => x)),
        "slotTimes": List<dynamic>.from(slotTimes!.map((x) => x)),
      };
}
