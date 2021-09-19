import 'package:astrologyapp/constants/constants.dart';
import 'package:flutter/material.dart';

class PgDialog {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String title, Color bgColor) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => true,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: bgColor,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        Text(title,
                            style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 15,
                        ),
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          pleaseWait,
                          style: TextStyle(color: Colors.blueAccent),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
