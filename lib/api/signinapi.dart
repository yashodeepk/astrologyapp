import 'package:astrologyapp/ChatUtils/userchat.dart';
import 'package:astrologyapp/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSignInProvider extends ChangeNotifier {
  bool isLoading = false;
  SharedPreferences? prefs;

  // GoogleSignInAccount? _user;
  // GoogleSignInAccount get user => _user!;
  Future googleLogin(bool? astrologer) async {
    prefs = await SharedPreferences.getInstance();

    if (astrologer == false) {
      final googleSignIn = GoogleSignIn();
      try {
        final googleUser = await googleSignIn.signIn();
        if (googleUser == null)
          return print("google user null");
        else {
          // _user = googleUser;

          final googleAuth = await googleUser.authentication;

          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          await FirebaseAuth.instance.signInWithCredential(credential);
          await prefs!.setString('type', userX);
          // prefs = await SharedPreferences.getInstance();

          isLoading = true;
          final currentUser = FirebaseAuth.instance.currentUser;

          if (currentUser != null) {
            print('user');
            // Check is already sign up
            final QuerySnapshot result = await FirebaseFirestore.instance
                .collection('users')
                .where('id', isEqualTo: currentUser.email)
                .get();
            final List<DocumentSnapshot> documents = result.docs;
            if (documents.length == 0) {
              print('user created');
              // Update data to server if new user
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.email)
                  .set({
                'name': currentUser.displayName,
                'email': currentUser.email,
                'photoUrl': currentUser.photoURL,
                'id': currentUser.uid,
                'createdAt':
                    DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                'chattingWith': null
              });

              // // Write data to local
              await prefs!.setString('id', currentUser.uid);
              await prefs!.setString('name', currentUser.displayName!);
              await prefs!.setString('photoUrl', currentUser.photoURL!);
              await prefs!.setString('type', userX);
            } else {
              DocumentSnapshot documentSnapshot = documents[0];
              UserChat userChat = UserChat.fromDocument(documentSnapshot);
              // Write data to local
              await prefs!.setString('id', userChat.id);
              await prefs!.setString('name', userChat.name);
              await prefs!.setString('photoUrl', userChat.photoUrl);
              await prefs!.setString('aboutMe', userChat.aboutMe);
              await prefs!.setString('type', userX);
            }
            print('user data storage on cloudstore success');
            isLoading = false;
            notifyListeners();
            Fluttertoast.showToast(msg: "Sign in success");
          } else {
            print('user data storage on cloudstore failed');
            Fluttertoast.showToast(msg: "Sign in fail");
            googleSignIn.disconnect();
            FirebaseAuth.instance.signOut();
            isLoading = false;
          }
          // Fluttertoast.showToast(msg: "Sign in success");

        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Sign in fail");
        googleSignIn.disconnect();
        FirebaseAuth.instance.signOut();
        print(e.toString());
      }
    } else if (astrologer == true) {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      await prefs!.setString('type', astrologerX);
      String email = googleUser!.email;
      FirebaseFirestore.instance
          .collection('Astrologer')
          .doc(email)
          .get()
          .then((onValue) async {
        if (onValue.exists) {
          try {
            //  SharedPreferences? prefs;
            final googleUser = await googleSignIn.signIn();
            if (googleUser == null)
              return print("google user null");
            else {
              // _user = googleUser;

              final googleAuth = await googleUser.authentication;

              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken,
              );
              await FirebaseAuth.instance.signInWithCredential(credential);
              //  prefs = await SharedPreferences.getInstance();

              isLoading = true;
              final currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser != null) {
                print('astrologer');
                // Check is already sign up
                final QuerySnapshot result = await FirebaseFirestore.instance
                    .collection('Astrologer')
                    .where('id', isEqualTo: currentUser.email)
                    .get();
                final List<DocumentSnapshot> documents = result.docs;
                if (documents.length == 0) {
                  print('user created');
                  // Update data to server if new user
                  FirebaseFirestore.instance
                      .collection('Astrologer')
                      .doc(currentUser.email)
                      .update({
                    'name': currentUser.displayName,
                    'email': currentUser.email,
                    'photoUrl': currentUser.photoURL,
                    'id': currentUser.uid,
                    'createdAt':
                        DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                    // 'chattingWith': null
                  });

                  // // Write data to local
                  await prefs!.setString('id', currentUser.uid);
                  await prefs!.setString('name', currentUser.displayName!);
                  await prefs!.setString('photoUrl', currentUser.photoURL!);
                  await prefs!.setString('type', astrologerX);
                } else {
                  DocumentSnapshot documentSnapshot = documents[0];
                  UserChat userChat = UserChat.fromDocument(documentSnapshot);
                  // Write data to local
                  await prefs!.setString('id', userChat.id);
                  await prefs!.setString('name', userChat.name);
                  await prefs!.setString('photoUrl', userChat.photoUrl);
                  await prefs!.setString('aboutMe', userChat.aboutMe);
                  await prefs!.setString('type', astrologerX);
                }
                print('user data storage on cloudstore success');
                isLoading = false;
                notifyListeners();
                Fluttertoast.showToast(msg: "Sign in success");
              } else {
                print('user data storage on cloudstore failed');
                await googleSignIn.disconnect();
                FirebaseAuth.instance.signOut();
                Fluttertoast.showToast(msg: "Sign in fail");
                isLoading = false;
              }
              // Fluttertoast.showToast(msg: "Sign in success");

            }
          } catch (e) {
            Fluttertoast.showToast(msg: "Sign in fail");
            await googleSignIn.disconnect();
            FirebaseAuth.instance.signOut();
            print(e.toString());
          }
        } else {
          await googleSignIn.disconnect();
          FirebaseAuth.instance.signOut();
          Fluttertoast.showToast(msg: "please register before login");
        }
      });
    }
  }

  Future logout() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
