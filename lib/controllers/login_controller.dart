import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:fyp/services/auth/sign_services.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/logger.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxBool ispassword = true.obs;
  RxBool isLoading = false.obs;
  LoggerService loggerService = LoggerService();
  UserPreference userPreference = UserPreference();
  RxString email = "".obs;
  RxString password = "".obs;
  final SignServices signServices = SignServices();
  final check = SignServices();

  void setEmail(String value) {
    email.value = value.toLowerCase();
  }

  void setPassword(String value) {
    password.value = value;
  }

  String get getEmail => email.value;
  String get getPassword => password.value;

  showPassword() {
    ispassword.value = !ispassword.value;
  }

  Future<void> login() async {
    try {
      //isLoading.value = true;

      await SignServices()
          .mySignIn(getEmail, getPassword)
          .then((value) async {});
    } catch (e) {
      Utils.myBoxShow("title", e.toString());
    } finally {
      //isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Sign out the previous Google account
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        // Google Sign-In canceled by user
        return;
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      // Sign in to Firebase with Google credentials
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        if (user.email!.endsWith('@gmail.com')) {
          bool userDataExists =
              await check.checkUserDataExists(userCredential.user!);
          if (!userDataExists) {
            await check.saveUserData(userCredential.user!);
          }
          // Successful login with Gmail account
          print('User: ${user.email} signed in');

          UserPreference prefs = await UserPreference();
          prefs.saveUserToken(user.email!);

          // Navigate to the home screen
          Get.toNamed(RoutesName.homeScreen);
        } else {
          // Show an error message to the user
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Please login with your Gmail account.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Sign out the user as the email is not allowed
                      FirebaseAuth.instance.signOut();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Handle authentication errors
      print('Error signing in with Google: $e');
    }
  }
}
