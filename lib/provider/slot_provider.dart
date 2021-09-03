import 'package:flutter/foundation.dart';

class SlotProvider with ChangeNotifier {
  String? _day, _date;
  String? _startTime;
  String? _endTime;
  List? _slotTimes;
  int? _order;

  get getDay => _day;

  get getDate => _date;

  get getStartTime => _startTime;

  get getEndTime => _endTime;

  get getSlotTimes => _slotTimes;

  get getOrder => _order;

  //notify listener
  saveSlot(day, date, startTime, endTime, slotTimes) {
    _day = day;
    _date = date;
    _startTime = startTime;
    _endTime = endTime;
    _slotTimes = slotTimes;

    notifyListeners();
  }

  //create record in database
  createSlot() {
    print(
        'start TIME $getStartTime  -- endTime $getEndTime -- day $getDay  -- date $getDate -- slots $getSlotTimes');
  }
}
