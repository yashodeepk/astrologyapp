import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AstrologerService {
  final firestoreService = FirebaseFirestore.instance;
  static AstrologerService? _instance;

  AstrologerService._();

  static AstrologerService get instance {
    return _instance == null ? _instance = AstrologerService._() : _instance!;
  }

//fetch all astrologers
  Stream<List<Astrologer>> getListOfAstrologers() {
    return firestoreService
        .collection(astrologerX)
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((document) => Astrologer.fromJson(document.data()))
            .toList(growable: true))
        .handleError((error) {
      print(error);
    });
  }
}
