import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SlotService {
  final firestoreService = FirebaseFirestore.instance;
  static SlotService? _instance;

  SlotService._();

  static SlotService get instance {
    return _instance == null ? _instance = SlotService._() : _instance!;
  }

//create new slot
  Future<void> createNewSlot(Slots slot) async {
    return await firestoreService
        .collection(astrologerX)
        .doc(email)
        .collection(slots)
        .doc(slot.day)
        .set(slot.toJson());
  }

  //fetch slots
  Stream<List<Slots>> getSlots() {
    return firestoreService
        .collection(astrologerX)
        .doc()
        .collection(slots)
        .orderBy("order", descending: false)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Slots.fromJson(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }
}
