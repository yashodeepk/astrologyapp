import 'package:astrologyapp/ChatUtils/Message.dart';
import 'package:astrologyapp/ChatUtils/newmsg.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: BackButton(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            BackButton(),
            CircleAvatar(
              backgroundImage: AssetImage('assets/bro.jpg'),
              radius: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Text(
                  'Kartik',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('online',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal))
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: Messages(),
              ),
              NewMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
