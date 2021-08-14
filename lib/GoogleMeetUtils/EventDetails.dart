import 'package:astrologyapp/GoogleMeetUtils/AddEvent.dart';
import 'package:astrologyapp/GoogleMeetUtils/Editevent.dart';
import 'package:astrologyapp/GoogleMeetUtils/StoreData.dart';
import 'package:astrologyapp/GoogleMeetUtils/eventinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Storage storage = Storage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
        title: Text(
          'Event Details',
          style: TextStyle(
            color: Colors.blue[900],
            fontSize: 22,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
