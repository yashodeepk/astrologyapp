import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:astrologyapp/service/slot_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SlotProvider with ChangeNotifier {
  String? _day, _date, _astrologerEmail, _slotToRemove;
  List? _slotTimes;
  List? _slotLists;
  int? _order;

  get getDay => _day;

  get getDate => _date;

  get getSlotToRemove => _slotToRemove;

  get getAstrologerEmail => _astrologerEmail;

  get getSlotTimes => _slotTimes;

  get getSlotList => _slotLists;

  //get getOrder => _order;

  //notify listener
  saveSlot(day, date, slotTimes, slotLists) {
    _day = day;
    _date = date;
    _slotTimes = slotTimes;
    _slotLists = slotLists;

    notifyListeners();
  }

  //removed booked slot
  removeBookedSlotFromList(day, astrologerEmail, slot) {
    _day = day;
    _astrologerEmail = astrologerEmail;
    _slotToRemove = slot;

    notifyListeners();
  }

  //notify listener
  updateSlotListener(day, slotTimes, slotLists) {
    _day = day;
    _slotTimes = slotTimes;
    _slotLists = slotLists;

    notifyListeners();
  }

  //create new slot record in database
  createSlot() {
    //assign order for days
    switch (getDay) {
      case monday:
        _order = 1;
        break;
      case tuesday:
        _order = 2;
        break;
      case wednesday:
        _order = 3;
        break;
      case thursday:
        _order = 4;
        break;
      case friday:
        _order = 5;
        break;
      case saturday:
        _order = 6;
        break;
      case sunday:
        _order = 7;
        break;
    }

    //create slot object
    Slots newSlots = Slots(
        id: FirebaseAuth.instance.currentUser!.uid,
        day: getDay,
        date: getDate,
        order: _order,
        slotTimes: getSlotTimes,
        slotList: getSlotList);

    SlotService.instance.createNewSlot(newSlots);
  }

  //update slot time
  updateSlot() {
    //update slot object
    Slots newSlots =
        Slots(day: getDay, slotTimes: getSlotTimes, slotList: getSlotList);

    SlotService.instance.updateSlot(newSlots);
  }

  //delete whole slot list
  deleteSlotTimeList() {
    //delete slot object
    Slots deleteSlot =
        Slots(day: getDay, slotTimes: getSlotTimes, slotList: getSlotList);

    SlotService.instance.deleteSlot(deleteSlot);
  }

  //remove or delete slot selected by user to book
  removeSelectedSlot() async {
    print('... $getDay ...$getAstrologerEmail /// $getSlotToRemove');
    //delete selected slot object
    SlotService.instance
        .deleteSelectedSlot(getAstrologerEmail, getDay, getSlotToRemove);
  }
}
