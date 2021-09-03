import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SlotService {
  final firestoreService = FirebaseFirestore.instance;
  static SlotService? _instance;

  SlotService._();

  static SlotService get instance {
    return _instance == null ? _instance = SlotService._() : _instance!;
  }

//create new slot
  Future<void> createNewSlot(Slots slot) {
    return firestoreService
        .collection(astrologerX)
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(slots)
        .doc(slot.day)
        .set(slot.toJson());
  }
}
