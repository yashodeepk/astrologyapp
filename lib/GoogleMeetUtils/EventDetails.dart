import 'package:astrologyapp/GoogleMeetUtils/StoreData.dart';
import 'package:astrologyapp/GoogleMeetUtils/slot_lists/SlotLists.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:astrologyapp/service/slot_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final astrologerEmail;
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key, this.astrologerEmail}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Storage storage = Storage();
  Astrologer? _astrologer;
  List<String> slotsLists = [];
  int? _getDay = DateTime.now().weekday;
  String? _day;
  bool isItemSelected = false;
  int _itemSelected = 0;
  int? _slotSelected;

  @override
  void initState() {
    getDayFromDateNow();
    final astrologersList =
        Provider.of<List<Astrologer>>(context, listen: false);
    _astrologer = astrologersList.firstWhere(
        (Astrologer astrologer) => astrologer.email == widget.astrologerEmail);

    super.initState();
  }

  getDayFromDateNow() {
    switch (_getDay) {
      case 1:
        _day = monday;
        break;
      case 2:
        _day = tuesday;
        break;
      case 3:
        _day = wednesday;
        break;
      case 4:
        _day = thursday;
        break;
      case 5:
        _day = friday;
        break;
      case 6:
        _day = saturday;
        break;
      case 7:
        _day = sunday;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'EVENT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //displays astrologers details
                        Container(
                          height: oneTwentyDp,
                          padding: EdgeInsets.symmetric(horizontal: thirtyDp),
                          decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(twentyDp),
                                  bottomRight: Radius.circular(twentyDp))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //image
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    '${_astrologer!.photoUrl}'),
                                radius: 40,
                              ),

                              //details
                              Container(
                                margin:
                                    EdgeInsets.only(left: twelveDp, top: tenDp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_astrologer!.name}",
                                      style: TextStyle(
                                          fontSize: twentyDp,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: eightDp),
                                        child: Text(
                                          "${_astrologer!.email}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: sixteenDp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        "${_astrologer!.expertise}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: sixteenDp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Text(
                            chooseYourSlot,
                            style: TextStyle(fontSize: sixteenDp),
                          ),
                        ),
                        buildItemSection(),
                        SizedBox(
                          height: sixteenDp,
                        ),

                        StreamBuilder<List<Slots>>(
                            stream: SlotService.instance
                                .getSelectedAstrologerSlots(
                                    widget.astrologerEmail, _day!),
                            builder: (context, snapshot) {
                              slotsLists.clear();
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Expanded(
                                    child: Center(
                                  child: CircularProgressIndicator(),
                                ));
                              } else if (snapshot.hasData) {
                                Slots sl = Slots();

                                for (int i = 0;
                                    i < snapshot.data!.length;
                                    i++) {
                                  sl = snapshot.data![i];

                                  for (int j = 0;
                                      j < sl.slotList!.length;
                                      j++) {
                                    slotsLists.add(sl.slotList![j]);
                                  }
                                }
                                return Builder(
                                  builder: (BuildContext context) {
                                    return SlotLists(
                                      slotList: slotsLists,
                                      astrologer: _astrologer,
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text('No slots'),
                                );
                              }
                            }),

                        //  buildContainer(),
                      ],
                    ),
                  ),
                  //  buildPaymentButton()
                ],
              ),
            )
          ],
        ),
      ),
      /*  floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[900],
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateScreen(),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: Container(
          padding: EdgeInsets.only(top: 8.0),
          color: Colors.white,
          child: StreamBuilder<QuerySnapshot>(
            stream: storage.retrieveEvents(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                // final x = snapshot.requireData;
                final data = snapshot.requireData;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.requireData.size,
                  itemBuilder: (context, i) {
                    Map<String, dynamic>? eventInfo =
                        data.docs[i].data() as Map<String, dynamic>?;

                    EventInfo event = EventInfo.fromMap(eventInfo!);

                    DateTime startTime = DateTime.fromMillisecondsSinceEpoch(
                        event.startTimeInEpoch);
                    DateTime endTime = DateTime.fromMillisecondsSinceEpoch(
                        event.endTimeInEpoch);

                    String startTimeString = DateFormat.jm().format(startTime);
                    String endTimeString = DateFormat.jm().format(endTime);
                    String dateString = DateFormat.yMMMMd().format(startTime);

                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditScreen(event: event),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                bottom: 16.0,
                                top: 16.0,
                                left: 16.0,
                                right: 16.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.name,
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    event.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
                                    child: Text(
                                      event.link,
                                      style: TextStyle(
                                        color: Colors.blue.shade900
                                            .withOpacity(0.5),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 5,
                                        color: Colors.green,
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dateString,
                                            style: TextStyle(
                                              color: Colors.cyan[900],
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          Text(
                                            '$startTimeString - $endTimeString',
                                            style: TextStyle(
                                              color: Colors.cyan[900],
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Text(
                    'No Events',
                    style: TextStyle(
                      color: Colors.black38,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                );
              }
              // if(snapshot.hasError){}
              // return Center(
              //   child: CircularProgressIndicator(
              //     strokeWidth: 2,
              //     valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),
              //   ),
              // );
            },
          ),
        ),
      ),*/
    );
  }

  Widget buildItemSection() {
    return Center(
      child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          child: ListView.builder(
              itemCount: 7,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              primary: true,
              itemBuilder: (ctx, position) {
                int day = DateTime.now().day + position;

                var ss = DateFormat('EE')
                    .format(DateTime.now().add(Duration(days: position)));

                return GestureDetector(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ss,
                          style: TextStyle(
                              color: _itemSelected == day
                                  ? Colors.black
                                  : Colors.grey[700],
                              fontSize: sixteenDp),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            height: 50,
                            width: 40,
                            margin: EdgeInsets.only(right: tenDp),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black54, width: 0.9),
                                color:
                                _day!.contains(ss) || _itemSelected == day
                                        ? Colors.blue[900]
                                        : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(sixDp)),
                            child: Text(
                                DateTime.now()
                                    .add(Duration(days: position))
                                    .day
                                    .toString(),
                                style: TextStyle(
                                  fontSize: twentyDp,
                                  color:
                                      _day!.contains(ss) || _itemSelected == day
                                          ? Colors.white
                                          : Colors.black87,
                                ))),
                      ],
                    ),
                    onTap: () {
                      switch (ss) {
                        case 'Mon':
                          _day = monday;
                          break;
                        case 'Tue':
                          _day = tuesday;
                          break;
                        case 'Wed':
                          _day = wednesday;
                          break;
                        case 'Thu':
                          _day = thursday;
                          break;
                        case 'Fri':
                          _day = friday;
                          break;
                        case 'Sat':
                          _day = saturday;
                          break;
                        case 'Sun':
                          _day = sunday;
                          break;
                      }

                      setState(() {
                        isItemSelected = false;
                        _itemSelected = DateTime.now().day + position;
                      });
                    });
              })),
    );
  }


}
