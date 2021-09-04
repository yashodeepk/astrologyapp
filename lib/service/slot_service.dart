import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SlotService {
  final firestoreService = FirebaseFirestore.instance;
  static SlotService? _instance;
  static String? _email;

  SlotService._();

  static SlotService get instance {
    if (FirebaseAuth.instance.currentUser != null) {
      _email = FirebaseAuth.instance.currentUser!.email;
      print("email is $_email");
    }
    return _instance == null ? _instance = SlotService._() : _instance!;
  }

//create new slot
  Future<void> createNewSlot(Slots slot) async {
    return await firestoreService
        .collection(astrologerX)
        .doc(_email)
        .collection(slots)
        .doc(slot.day)
        .set(slot.toJson());
  }

  //update slot
  Future<void> updateSlot(Slots slot) async {
    return await firestoreService
        .collection(astrologerX)
        .doc(_email)
        .collection(slots)
        .doc(slot.day)
        .update({
      "slotTimes": FieldValue.arrayUnion(slot.slotTimes!),
      'slotList': FieldValue.arrayUnion(slot.slotList!)
    }).onError((error, stackTrace) {
      print("?????? -- $error");
    });
  }

  //fetch slots
  Stream<List<Slots>> getSlots() {
    return firestoreService
        .collection(astrologerX)
        .doc(_email)
        .collection(slots)
        .orderBy("order", descending: false)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Slots.fromJson(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print("error --- $error");
    });
  }
}
