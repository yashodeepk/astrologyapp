import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      "121239416780-kan19lh4caieskosdm6pkhlh9pba9dou.apps.googleusercontent.com";
  static const IOS_CLIENT_ID =
      "121239416780-1a0cp9jgd2jj7mfeq45eebjs71d24vuk.apps.googleusercontent.com";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
  //static String getId() => Secret.ANDROID_CLIENT_ID;
}
