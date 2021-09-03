import 'package:astrologyapp/bottom_sheets/add_schedule.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SchedulesPage extends StatefulWidget {
  static const String routeName = '/schedulesPage';

  const SchedulesPage({Key? key}) : super(key: key);

  @override
  _SchedulesPageState createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final slotsList = Provider.of<List<Slots>>(context);
    print(slotsList.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          schedules,
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => AddSchedule());
        },
        child: Icon(Icons.add),
        tooltip: addSchedule,
      ),
      body: Container(
        child: Builder(
            builder: (context) => ListView.builder(
                  itemBuilder: (context, index) {
                    Slots slots = slotsList[index];

                    return Center(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(sixteenDp),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                slots.day,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: twentyDp,
                                    color: Colors.black),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${slots.startAt}  -  ',
                                    style: TextStyle(
                                        fontSize: twentyDp,
                                        color: Colors.black45),
                                  ),
                                  Text(
                                    slots.endAt,
                                    style: TextStyle(
                                        fontSize: twentyDp,
                                        color: Colors.black45),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: slotsList.length,
                  shrinkWrap: true,
                )),
      ),
    );
  }
}
