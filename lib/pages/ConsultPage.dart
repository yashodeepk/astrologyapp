import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ConsultWidget extends StatefulWidget {
  @override
  _ConsultWidgetState createState() => _ConsultWidgetState();
}

class _ConsultWidgetState extends State<ConsultWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'Consult',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 5,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        scrollDirection: Axis.vertical,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent[400],
              // gradient: LinearGradient(
              //     begin: Alignment.centerLeft,
              //     end: Alignment.centerRight,
              //     colors: [Color(0xfffe8c00), Color(0xfff83600)]),
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/bro.jpg'),
                            radius: 30,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Icon(
                                Icons.star_rate,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            ),
                            Container(
                              // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              // padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.star_rate,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            ),
                            Container(
                              // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              // padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.star_rate,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              // padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              // padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.star_rate,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              // padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.star_rate,
                                color: Color(0xFFFFD700),
                                size: 24,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 1, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Shivam Karle',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: AutoSizeText(
                                    'Marriage, Career, Job, Study. Love',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Column(
                    //   mainAxisSize: MainAxisSize.max,
                    //   children: [
                    //     Expanded(
                    //       child: IconButton(
                    //         icon: Icon(
                    //           Icons.arrow_forward_ios,
                    //           color: Color(0xff22262B),
                    //           size: 24,
                    //         ),
                    //         onPressed: () {},
                    //       ),
                    //     )
                    //   ],
                    // )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Fess  - ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          ' ₹',
                          style: TextStyle(
                            color: Color(0xFF22262B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      label: Text('Book Meeting'),
                      icon: Icon(
                        Icons.call_rounded,
                        size: 15,
                      ),
                      style: TextButton.styleFrom(
                        // padding: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        primary: Colors.white,
                        backgroundColor: Color(0xff4c3cb0),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
