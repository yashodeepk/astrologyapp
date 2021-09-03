import 'package:astrologyapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AddDayAndTimeAvailable extends StatefulWidget {
  const AddDayAndTimeAvailable({Key? key}) : super(key: key);

  @override
  _AddDayAndTimeAvailableState createState() => _AddDayAndTimeAvailableState();
}

class _AddDayAndTimeAvailableState extends State<AddDayAndTimeAvailable> {
  String? _selectedDay;
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  _selectTime(BuildContext context, TextEditingController? controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
        controller!.text = selectedStartTime.format(context);
      });
    } else {
      setState(() {
        controller!.text = selectedStartTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
          color: Colors.blueGrey[700],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: sixteenDp,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: twentyDp),
              child: Text(
                selectDay,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),

            buildSelectedDay(),
            SizedBox(
              height: sixteenDp,
            ),

            //starting and ending time
            Row(
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    buildTime(endTimeController)
                  ],
                ),
              ],
            ),
            SizedBox(
              height: thirtyDp,
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: twentyDp),
              child: RaisedButton(
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                color: Colors.blueAccent,
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(
                    'ADD',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
      child: TextField(
        cursorColor: Colors.blueAccent,
        controller: controller,
        onTap: () => _selectTime(context, controller),
        readOnly: true,
        style: TextStyle(
          color: Colors.white,
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
          errorText: controller.text.isNotEmpty ? null : 'time can\'t be empty',
          errorStyle: TextStyle(
            fontSize: 12,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}