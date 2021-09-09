import 'package:astrologyapp/GoogleMeetUtils/StoreData.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:astrologyapp/model/users.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    final astrologersList =
        Provider.of<List<Astrologer>>(context, listen: false);
    _astrologer = astrologersList.firstWhere(
        (Astrologer astrologer) => astrologer.email == widget.astrologerEmail);
    super.initState();
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
          'Event',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: oneFiftyDp,
            padding: EdgeInsets.symmetric(horizontal: thirtyDp),
            decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(thirtyDp),
                    bottomRight: Radius.circular(thirtyDp))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //image
                CircleAvatar(
                  backgroundImage:
                      CachedNetworkImageProvider('${_astrologer!.photoUrl}'),
                  radius: fiftyDp,
                ),

                //details
                Container(
                  margin: EdgeInsets.only(left: twentyDp, top: tenDp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_astrologer!.name}",
                        style:
                            TextStyle(fontSize: twentyDp, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: eightDp),
                        child: Text(
                          "${_astrologer!.email}",
                          style: TextStyle(
                              fontSize: sixteenDp, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          "${_astrologer!.expertise}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: sixteenDp, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
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
}
