import 'dart:io' show Platform;

class Secret {
  static const ANDROID_CLIENT_ID =
      //"121239416780-kan19lh4caieskosdm6pkhlh9pba9dou.apps.googleusercontent.com";
      "121239416780-aa58f00qaf9okeboib3gbj05odhm98h4.apps.googleusercontent.com";
  static const IOS_CLIENT_ID =
      //"121239416780-1a0cp9jgd2jj7mfeq45eebjs71d24vuk.apps.googleusercontent.com";
      "121239416780-70kc6jdjejj1ht712t8ohrl6f5ahbom2.apps.googleusercontent.com";
  static String getId() =>
      Platform.isAndroid ? Secret.ANDROID_CLIENT_ID : Secret.IOS_CLIENT_ID;
  //static String getId() => Secret.ANDROID_CLIENT_ID;
}
