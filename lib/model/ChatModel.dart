import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.idFrom,
    required this.idTo,
    required this.imageFrom,
    required this.imageTo,
    required this.nameFrom,
    required this.nameTo,
  });

  final String idFrom;
  final String idTo;
  final String nameTo;
  final String imageTo;

  final String imageFrom;
  final String nameFrom;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        idFrom: json["idFrom"],
        idTo: json["idTo"],
        imageTo: json["imageTo"],
        nameTo: json["nameTo"],
        imageFrom: json["imageFrom"],
        nameFrom: json["nameFrom"],
      );

  Map<String, dynamic> toJson() => {
        "idFrom": idFrom,
        "idTo": idTo,
        "imageTo": imageTo,
        "nameTo": nameTo,
        "imageFrom": imageFrom,
        "nameFrom": nameFrom,
      };
}
