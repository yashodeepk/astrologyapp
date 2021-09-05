import 'package:astrologyapp/actions/actions.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:astrologyapp/provider/slot_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class AddSchedule extends StatefulWidget {
  Slots? slots;
  List? day;

  AddSchedule({Key? key, required this.day}) : super(key: key);

  AddSchedule.addAnotherSlot({Key? key, this.slots}) : super(key: key);

  @override
  _AddScheduleState createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  String? _selectedDay;
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  int? startHour, startMinute, endHour, endMinute;
  SlotProvider _slotProvider = SlotProvider();
  final _formKey = GlobalKey<FormState>();
  List slotTimes = [];
  List slotTimeList = []; //adds all slot lists available
  int intervalDuration = 30;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        height: widget.slots == null
            ? MediaQuery.of(context).size.height * 0.4
            : MediaQuery.of(context).size.height * 0.6,
        padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: sixteenDp,
              ),
              widget.slots == null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: twentyDp),
                      child: Text(
                        widget.slots == null
                            ? createNewSlot
                            : '$addAnotherSlot for ${widget.slots!.day}',
                        style: TextStyle(
                            fontSize:
                                widget.slots == null ? sixteenDp : twentyDp,
                            color: Colors.black),
                      ),
                    )
                  : Center(
                      child: Text(
                        "${widget.slots!.day}",
                        style:
                            TextStyle(fontSize: twentyDp, color: Colors.black),
                      ),
                    ),

              widget.slots == null ? buildSelectedDay() : buildSlotTimeList(),
              SizedBox(
                height: sixteenDp,
              ),

              //starting and ending time
              widget.slots != null && widget.slots!.slotTimes!.length == 4
                  ? Container()
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //start
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: twentyDp, vertical: fourDp),
                              child: Text(
                                startTime,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                            buildTime(startTimeController)
                          ],
                        ),
                        //end
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: twentyDp, vertical: fourDp),
                              child: Text(
                                endTime,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ),
                            buildTime(endTimeController)
                          ],
                        ),
                      ],
                    ),
              widget.slots != null && widget.slots!.slotTimes!.length == 4
                  ? Container()
                  : SizedBox(
                      height: thirtyDp,
                    ),

              //add slot button
              widget.slots != null && widget.slots!.slotTimes!.length == 4
                  ? Container()
                  : addSlotButton(),
            ],
          ),
        ),
      ),
    );
  }

  //function to select start time
  _selectStartTime(
      BuildContext context, TextEditingController? controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        controller!.text = selectedStartTime.format(context);
        startHour = selectedStartTime.hour;
        startMinute = selectedStartTime.minute;
      });
    } else {
      setState(() {
        controller!.text = selectedStartTime.format(context);
      });
    }
  }

  //end time
  _selectEndTime(
      BuildContext context, TextEditingController? controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        controller!.text = selectedStartTime.format(context);
        endHour = selectedStartTime.hour;
        endMinute = selectedStartTime.minute;
      });
    } else {
      setState(() {
        controller!.text = selectedStartTime.format(context);
      });
    }
  }

  //function to split time intervals for slots
  Iterable<TimeOfDay> getSlotTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration interval) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += interval.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }

  //drop down for selecting day
  Widget buildSelectedDay() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: twentyDp, vertical: tenDp),
      child: Container(
        padding: EdgeInsets.all(sixDp),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(eightDp),
            border:
                Border.all(width: 0.5, color: Colors.grey.withOpacity(0.5))),
        child: DropdownButtonFormField<String>(
          value: _selectedDay,
          elevation: 1,
          isExpanded: true,
          style: TextStyle(color: Color(0xFF424242)),
          // underline: Container(),
          items: [
            monday,
            tuesday,
            wednesday,
            thursday,
            friday,
            saturday,
            sunday
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          hint: Text(
            pleaseSelectDay,
            style: TextStyle(color: Color(0xFF757575), fontSize: sixteenDp),
          ),
          onChanged: (String? value) {
            setState(() {
              _selectedDay = value;
            });
          },
          validator: (value) => value == null ? dayRequired : null,
        ),
      ),
    );
  }

  //time
  Widget buildTime(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: twentyDp),
      width: oneFiftyDp,
      child: TextFormField(
        validator: (value) => value!.isNotEmpty ? null : 'time can\'t be empty',
        cursorColor: Colors.blueAccent,
        controller: controller,
        onTap: () => controller == startTimeController
            ? _selectStartTime(context, controller)
            : _selectEndTime(context, controller),
        readOnly: true,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        decoration: new InputDecoration(
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.blue.shade900, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.redAccent, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          contentPadding: EdgeInsets.only(
            left: 16,
            bottom: 16,
            top: 16,
            right: 16,
          ),
          hintText: 'eg: 09:30 AM',
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          // errorText: controller.text.isNotEmpty ? null : 'time can\'t be empty',
          errorStyle: TextStyle(
            fontSize: 12,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  //build add slot button
  Widget addSlotButton() {
    return Center(
      child: Container(
        //width: double.maxFi,
        margin: EdgeInsets.symmetric(horizontal: twentyDp),
        child: RaisedButton(
          elevation: 0,
          focusElevation: 0,
          highlightElevation: 0,
          color: Colors.blueAccent,
          onPressed: () => triggerAction(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Text(
              widget.slots == null ? addSlot : addAnotherSlot,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: sixteenDp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  triggerAction() async {
    //1. check if slots is not null
    widget.slots != null ? await addMoreSlot() : await createSlot();
  }

  //update or add another slot
  addMoreSlot() async {
    //check if selected time is not null
    if (startHour != null &&
        startMinute != null &&
        endHour != null &&
        endMinute != null) {
      someMethod(startHour, startMinute, endHour, endMinute);

      //check if time has 30 minutes interval
      if (startMinute! % intervalDuration != 0 ||
          endMinute! % intervalDuration != 0) {
        ShowAction.showDetails(
            slotAlertTitle,
            slotTimeInterval,
            context,
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(ok)));
      }
      //check if the time selected or slots matches existing slots
      else if (widget.slots!.slotList!
          .any((element) => slotTimeList.contains(element))) {
        ShowAction.showDetails(
            slotAlertTitle,
            slotTimeSlotErrorDescription,
            context,
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(ok)));
      } else {
        //save to listeners
        _slotProvider.updateSlotListener(
            widget.slots!.day!, slotTimes, slotTimeList);
        //create slot for day
        _slotProvider.updateSlot();
        Navigator.of(context).pop();
        ShowAction().showToast(successful, Colors.green);
      }
    }
  }

  createSlot() async {
    //validate form key
    if (_formKey.currentState!.validate()) {
      //check if selected time is not null
      if (startHour != null &&
          startMinute != null &&
          endHour != null &&
          endMinute != null) {
        someMethod(startHour, startMinute, endHour, endMinute);

        var date = convertDateTimeDisplay(DateTime.now().toString());

        //check if slot for day is already created
        if (widget.day != null && widget.day!.contains(_selectedDay)) {
          ShowAction.showDetails(
              slotAlertTitle,
              slotAlertDescription,
              context,
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text(ok)));
        } else {
          //save to listeners
          _slotProvider.saveSlot(_selectedDay, date, slotTimes, slotTimeList);
          //create slot for day
          _slotProvider.createSlot();
          Navigator.of(context).pop();
          ShowAction().showToast(successful, Colors.green);
        }
      }
    }
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat dateOnly = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = dateFormat.parse(date);
    final String formattedDate = dateOnly.format(displayDate);
    return formattedDate;
  }

  //show when astrologer wants to add another slot
  Widget buildSlotTimeList() {
    return Container(
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            minVerticalPadding: 0,
            leading: Text(
              widget.slots!.slotTimes![index],
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: sixteenDp),
            ),
            trailing: GestureDetector(
              onTap: () {
                ShowAction.showAlertDialog(
                    deleteSlot,
                    deleteDescription,
                    context,
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () => delete(index),
                        child: Text(yes)),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(no)));
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          );
        },
        itemCount: widget.slots!.slotTimes!.length,
        shrinkWrap: true,
      ),
    );
  }

  ///hardest task so far
  void delete(index) {
    Navigator.of(context).pop();
    Navigator.of(context, rootNavigator: true).pop();

    var splitAndExtractTime = widget.slots!.slotTimes![index]
        .toString()
        .replaceAll(RegExp("[\s-\s]"), '');

    String startTimer = splitAndExtractTime.toString().split('-')[0].toString();

    String endTimer = splitAndExtractTime.toString().split('-')[1].toString();

    slotTimes.add('$startTimer-$endTimer');

    TimeOfDay startTimeOfDay = stringToTimeOfDay(startTimer);
    TimeOfDay endTimeOfDay = stringToTimeOfDay(endTimer.substring(1));

    someMethod(startTimeOfDay.hour, startTimeOfDay.minute, endTimeOfDay.hour,
        endTimeOfDay.minute);

    _slotProvider.updateSlotListener(
        widget.slots!.day, slotTimes, slotTimeList);
    _slotProvider.deleteSlotTimeList();
    ShowAction().showToast(successful, Colors.green);
  }

  //this method takes a string and converts it to time
  TimeOfDay stringToTimeOfDay(String timeOfDay) {
    final format = DateFormat.jm();
    return TimeOfDay.fromDateTime(format.parse(timeOfDay));
  }

  void someMethod(
      int? startHour, int? startMinute, int? endHour, int? endMinute) {
    final startTime = TimeOfDay(hour: startHour!, minute: startMinute!);
    final endTime = TimeOfDay(hour: endHour!, minute: endMinute!);
    final interval = Duration(minutes: intervalDuration);
    print('st ? $startTime -- end $endTime');
    if (_formKey.currentState!.validate()) {
      // adds start and end time
      slotTimes.add('${startTimeController.text} - ${endTimeController.text}');
    }

//split times
    final times = getSlotTimes(startTime, endTime, interval)
        .map((slotsTime) => slotsTime.format(context))
        .toList();

    for (int i = 0; i < times.length - 1; i++) {
      //add to list
      slotTimeList.add('${times[i]} - ${times[i + 1]}');
    }
  }
}
