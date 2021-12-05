import 'package:astrologyapp/Colors.dart';
import 'package:astrologyapp/GoogleMeetUtils/StoreData.dart';
import 'package:astrologyapp/GoogleMeetUtils/slot_lists/SlotLists.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/slot.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:astrologyapp/service/slot_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
  String? _dayOfWeek;
  bool isItemSelected = false;
  int _itemSelected = 0;

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
        _dayOfWeek = monday;
        break;
      case 2:
        _dayOfWeek = tuesday;
        break;
      case 3:
        _dayOfWeek = wednesday;
        break;
      case 4:
        _dayOfWeek = thursday;
        break;
      case 5:
        _dayOfWeek = friday;
        break;
      case 6:
        _dayOfWeek = saturday;
        break;
      case 7:
        _dayOfWeek = sunday;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text(
          'Book Meeting',
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
      ),
      body: Container(
        // padding: EdgeInsets.only(top: 40),
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
                          // height: oneTwentyDp,
                          padding: EdgeInsets.only(top: 90, bottom: 30),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: GradientTemplate
                                      .gradientTemplate[0].colors.last
                                      .withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2.5,
                                  offset: Offset(3, 3),
                                ),
                              ],
                              gradient: LinearGradient(
                                colors:
                                    GradientTemplate.gradientTemplate[0].colors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              // color: Colors.blue[900],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32),
                                  bottomRight: Radius.circular(32))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //image
                              CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    image: '${_astrologer!.photoUrl}',
                                    placeholder: 'assets/images/bro.jpg',
                                    imageErrorBuilder:
                                        (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/images/bro.jpg',
                                          fit: BoxFit.fitWidth);
                                    },
                                  ),
                                ),
                                radius: 40,
                              ),

                              //details
                              Container(
                                width: MediaQuery.of(context).size.width * 0.6,
                                // margin:
                                //     EdgeInsets.only(left: twelveDp, top: tenDp),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            "${_astrologer!.name}"
                                                .toUpperCase(),
                                            maxLines: 1,
                                            // textAlign: TextAlign.start,
                                            // overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: twentyDp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 8.0),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.start,
                                    //     children: [
                                    //       Expanded(
                                    //         child: AutoSizeText(
                                    //           "${_astrologer!.email}",
                                    //           // overflow: TextOverflow.ellipsis,
                                    //           style: TextStyle(
                                    //               fontSize: sixteenDp,
                                    //               color: Colors.white70),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: AutoSizeText(
                                              "${_astrologer!.expertise}",
                                              // overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: sixteenDp,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
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
                                    widget.astrologerEmail, _dayOfWeek!),
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
                                      day: _itemSelected,
                                      dayOfWeek: _dayOfWeek,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          ss, //AutoSizeText will automaticaly chage text size to maxmimun fit inside coloum it will solve RenderFlex overflowed error
                          style: TextStyle(
                              color: _itemSelected == day
                                  ? Colors.blue.shade800
                                  : Colors.black),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Container(
                            height: 50,
                            width: 40,
                            margin: EdgeInsets.only(left: 5, right: 5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 0.9),
                                color: _dayOfWeek!.contains(ss) ||
                                        _itemSelected == day
                                    ? Colors.blue[900]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(sixDp)),
                            child: Text(
                                DateTime.now()
                                    .add(Duration(days: position))
                                    .day
                                    .toString(),
                                style: TextStyle(
                                  fontSize: twentyDp,
                                  color: _dayOfWeek!.contains(ss) ||
                                          _itemSelected == day
                                      ? Colors.white
                                      : Colors.black87,
                                ))),
                      ],
                    ),
                    onTap: () {
                      switch (ss) {
                        case 'Mon':
                          _dayOfWeek = monday;
                          break;
                        case 'Tue':
                          _dayOfWeek = tuesday;
                          break;
                        case 'Wed':
                          _dayOfWeek = wednesday;
                          break;
                        case 'Thu':
                          _dayOfWeek = thursday;
                          break;
                        case 'Fri':
                          _dayOfWeek = friday;
                          break;
                        case 'Sat':
                          _dayOfWeek = saturday;
                          break;
                        case 'Sun':
                          _dayOfWeek = sunday;
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
