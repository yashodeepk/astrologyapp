import 'package:astrologyapp/pages/AccountPage.dart';
import 'package:astrologyapp/pages/HomePage.dart';
import 'package:astrologyapp/pages/MeetingHistory_page/MeetingHistory.dart';
import 'package:astrologyapp/pages/PaymentHistory_page/PaymentHistoryPage.dart';
import 'package:astrologyapp/pages/schedules_page/schedules.dart';
import 'package:astrologyapp/paymentMethodUtils/RazorpayPayment.dart';
import 'package:flutter/material.dart';

import 'GoogleMeetUtils/AddEvent.dart';
import 'GoogleMeetUtils/EventDetails.dart';
import 'api/config_page.dart';
import 'main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
//config page
      case ConfigurationPage.routeName:
        return MaterialPageRoute(builder: (_) => ConfigurationPage());

      case Home.routeName:
        return MaterialPageRoute(builder: (_) => Home());

      case AccountPageWidget.routeName:
        return MaterialPageRoute(builder: (_) => AccountPageWidget());

      case HomePageWidget.routeName:
        return MaterialPageRoute(builder: (_) => HomePageWidget());

      case SchedulesPage.routeName:
        return MaterialPageRoute(builder: (_) => SchedulesPage());

      case PaymentPage.routeName:
        return MaterialPageRoute(builder: (_) => PaymentPage());

      case PaymentHistoryPage.routeName:
        return MaterialPageRoute(builder: (_) => PaymentHistoryPage());

      case MeetingHistoryPage.routeName:
        return MaterialPageRoute(builder: (_) => MeetingHistoryPage());

      case CreateScreen.routeName:
        return MaterialPageRoute(builder: (_) => CreateScreen());

      case DashboardScreen.routeName:
        final data = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => DashboardScreen(
                  astrologerEmail: data,
                ));
      default:
        return _errorRoute();
    }
  }

  //error page ..
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Center(
          child: Text("Page not Found"),
        ),
      );
    });
  }
}
