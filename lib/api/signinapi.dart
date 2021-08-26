import 'package:astrologyapp/ChatUtils/userchat.dart';
import 'package:astrologyapp/LoginPageUtils/Astrologerinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool astrologer = false;

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();
  SharedPreferences? prefs;

  bool isLoading = false;
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;
  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null)
        return print("google user null");
      else {
        _user = googleUser;

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (astrologer) {
          prefs = await SharedPreferences.getInstance();

          isLoading = true;
          final currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser != null) {
            print('user');
            // Check is already sign up
            final QuerySnapshot result = await FirebaseFirestore.instance
                .collection('users')
                .where('id', isEqualTo: currentUser.uid)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            if (documents.length == 0) {
              print('user created');
              // Update data to server if new user
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .set({
                'name': currentUser.displayName,
                'photoUrl': currentUser.photoURL,
                'id': currentUser.uid,
                'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
                'chattingWith': null
              });

              // Write data to local
              await prefs?.setString('id', currentUser.uid);
              await prefs?.setString('name', currentUser.displayName!);
              await prefs?.setString('photoUrl', currentUser.photoURL!);
            } else {
              DocumentSnapshot documentSnapshot = documents[0];
              UserChat userChat = UserChat.fromDocument(documentSnapshot);
              // Write data to local
              await prefs?.setString('id', userChat.id);
              await prefs?.setString('name', userChat.name);
              await prefs?.setString('photoUrl', userChat.photoUrl);
              await prefs?.setString('aboutMe', userChat.aboutMe);
            }
            print('user data storage on cloudstore success');
            isLoading = false;
          } else {
            print('user data storage on cloudstore failed');
            // Fluttertoast.showToast(msg: "Sign in fail");
            isLoading = false;
          }
          // Fluttertoast.showToast(msg: "Sign in success");
        }
        // else {
        //   prefs = await SharedPreferences.getInstance();

        //   final currentUser = FirebaseAuth.instance.currentUser;
        //   isLoading = true;

        //   // if (googleUser != null) {

        //   if (currentUser != null) {
        //     print('astrologer');
        //     // Check is already sign up
        //     final QuerySnapshot result = await FirebaseFirestore.instance
        //         .collection('tempreryastrologers')
        //         .where('id', isEqualTo: currentUser.uid)
        //         .get();
        //     final List<DocumentSnapshot> documents = result.docs;
        //     if (documents.length == 0) {
        //       print('astro user created');
        //       // Update data to server if new user
        //       FirebaseFirestore.instance
        //           .collection('astrologers')
        //           .doc(currentUser.uid)
        //           .set({
        //         'name': currentUser.displayName,
        //         'photoUrl': currentUser.photoURL,
        //         'id': currentUser.uid,
        //         'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        //         'about': experienceController,
        //         'chattingWith': null
        //       });

        //       // Write data to local
        //       await prefs?.setString('id', currentUser.uid);
        //       await prefs?.setString('name', currentUser.displayName!);
        //       await prefs?.setString('photoUrl', currentUser.photoURL!);
        //     } else {
        //       DocumentSnapshot documentSnapshot = documents[0];
        //       UserChat userChat = UserChat.fromDocument(documentSnapshot);
        //       // Write data to local
        //       await prefs?.setString('id', userChat.id);
        //       await prefs?.setString('name', userChat.name);
        //       await prefs?.setString('photoUrl', userChat.photoUrl);
        //       await prefs?.setString('about', userChat.aboutMe);
        //     }
        //     // Fluttertoast.showToast(msg: "Sign in success");
        //     print('data storage on cloudstore success');
        //     isLoading = false;
        //   } else {
        //     // Fluttertoast.showToast(msg: "Sign in fail");
        //     print('data storage on cloudstore failed');
        //     isLoading = false;
        //   }
        // }
      }
      Fluttertoast.showToast(msg: "Sign in success");
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}

// class SignNotifier extends ChangeNotifier {
//   String zodiacsign = 'assets/Rive/Aquarius.riv';
//   String zodiacsignName = 'Aquarius';
//   void zodiacsignchange(String zodiacsign1, String zodiacsignName) {
//     zodiacsign = zodiacsign1;
//     zodiacsignName = zodiacsignName;
//     notifyListeners();
//   }
// }

// class Firebaseauthuser {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   SharedPreferences? prefs;

//   bool isLoading = false;
//   bool isLoggedIn = false;
//   User? currentUser;

//   // @override
//   // void initState() {
//   //   super.initState();
//   // }

//   // void isSignedIn() async {
//   //   this.setState(() {
//   //     isLoading = true;
//   //   });

//   //   prefs = await SharedPreferences.getInstance();

//   //   isLoggedIn = await googleSignIn.isSignedIn();
//   //   if (isLoggedIn && prefs?.getString('id') != null) {
//   //     Navigator.pushReplacement(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => HomeScreen(currentUserId: prefs!.getString('id') ?? "")),
//   //     );
//   //   }

//   //   this.setState(() {
//   //     isLoading = false;
//   //   });
//   // }

//   Future<Null> handleSignIn() async {
//     prefs = await SharedPreferences.getInstance();

//     isLoading = true;

//     GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//     if (googleUser != null) {
//       GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       User? firebaseUser =
//           (await firebaseAuth.signInWithCredential(credential)).user;

//       if (firebaseUser != null) {
//         // Check is already sign up
//         final QuerySnapshot result = await FirebaseFirestore.instance
//             .collection('users')
//             .where('id', isEqualTo: firebaseUser.uid)
//             .get();
//         final List<DocumentSnapshot> documents = result.docs;
//         if (documents.length == 0) {
//           // Update data to server if new user
//           FirebaseFirestore.instance
//               .collection('users')
//               .doc(firebaseUser.uid)
//               .set({
//             'name': firebaseUser.displayName,
//             'photoUrl': firebaseUser.photoURL,
//             'id': firebaseUser.uid,
//             'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
//             'chattingWith': null
//           });

//           // Write data to local
//           currentUser = firebaseUser;
//           await prefs?.setString('id', currentUser!.uid);
//           await prefs?.setString('name', currentUser!.displayName ?? "");
//           await prefs?.setString('photoUrl', currentUser!.photoURL ?? "");
//         } else {
//           DocumentSnapshot documentSnapshot = documents[0];
//           UserChat userChat = UserChat.fromDocument(documentSnapshot);
//           // Write data to local
//           await prefs?.setString('id', userChat.id);
//           await prefs?.setString('name', userChat.name);
//           await prefs?.setString('photoUrl', userChat.photoUrl);
//           await prefs?.setString('aboutMe', userChat.aboutMe);
//         }
//         Fluttertoast.showToast(msg: "Sign in success");
//         isLoading = false;
//       } else {
//         Fluttertoast.showToast(msg: "Sign in fail");
//         isLoading = false;
//       }
//     } else {
//       Fluttertoast.showToast(msg: "Can not init google sign in");
//       isLoading = false;
//     }
//   }
// }
