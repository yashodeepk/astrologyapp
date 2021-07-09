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
        backgroundColor: Color(0xFFFFDD00),
        automaticallyImplyLeading: false,
        title: Text(
          'Consult',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 8,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Color(0xFF03DAC6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/512x512bb.jpg',
                                  width: 74,
                                  height: 74,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8, 1, 0, 0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Shivam Karle',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 110, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Icon(
                                          Icons.star_rate,
                                          color: Color(0xFFFFD700),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.star_rate,
                                          color: Color(0xFFFFD700),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.star_rate,
                                          color: Color(0xFFFFD700),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.star_rate,
                                          color: Color(0xFFFFD700),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(
                                          Icons.star_rate,
                                          color: Color(0xFFFFD700),
                                          size: 24,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        'Pandit Sri Shivam Karle Solving Your Life Issues Like Marriage, Career, Job, Study. Love',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: Text(
                                          'Fess  -',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Text(
                                          '5 Rs/min',
                                          style: TextStyle(
                                            color: Color(0xFFFFDD00),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
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
                                          fixedSize: Size(150, 40),
                                          primary: Color(0xFF4C3CB0),
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                          ),
                                          elevation: 8,
                                          side: BorderSide(
                                            color: Color(0xE0303030),
                                            width: 1,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
