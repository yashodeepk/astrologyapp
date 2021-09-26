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
  List day = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final slotsList = Provider.of<List<Slots>>(context);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: Text(
          schedules,
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () async {
          await showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => AddSchedule(
                    day: day,
                  ));
        },
        child: Icon(Icons.add),
        tooltip: addSchedule,
      ),
      body: Container(
        child: Builder(
            builder: (context) => ListView.builder(
                  itemBuilder: (context, index) {
                    Slots slots = slotsList[index];
                    day.add(slots.day);
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 5, right: 5, bottom: 0),
                      child: Center(
                        child: Card(
                          color: Colors.grey.withOpacity(0.3),
                          elevation: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: eightDp, left: eightDp),
                                child: Text(
                                  slots.day!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: twentyDp,
                                      color: Colors.black),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(top: fourDp),
                                    width: oneFiftyDp,
                                    child: ListView.builder(
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: eightDp, bottom: eightDp),
                                          child: Text(
                                            '${slots.slotTimes![index]}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black45),
                                          ),
                                        );
                                      },
                                      itemCount: slots.slotTimes!.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        await showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) =>
                                                AddSchedule.addAnotherSlot(
                                                  slots: slots,
                                                ));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ))
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
