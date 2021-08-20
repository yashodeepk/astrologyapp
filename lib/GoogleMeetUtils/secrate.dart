// import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      "749828102104-urpvi5dplkrokkothirkgt4kcu4qg2a0.apps.googleusercontent.com";
  // static const IOS_CLIENT_ID = "<enter your iOS client secret>";
  // static String getId() =>
  //     Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
  static String getId() => Secret.ANDROID_CLIENT_ID;
}
