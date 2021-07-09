import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:astrologyapp/pages/ChatPage.dart';
import 'package:astrologyapp/pages/ConsultPage.dart';
import 'package:astrologyapp/pages/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 0;

  final _pageOptions = [
    HomePageWidget(),
    ConsultWidget(),
    ChatWidget(),
    AccountPageWidget()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pageOptions[selectedPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF03ADC6),
        backgroundColor: Color(0xFF22262B),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.trip_origin_rounded),
            label: 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_sharp),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_saver_on_rounded),
            label: 'Database',
          ),
        ],
        currentIndex: selectedPage,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
