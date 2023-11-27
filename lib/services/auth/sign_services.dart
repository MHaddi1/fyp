import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/components/suggestions/my_text_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/logger.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../SharedPrefernece/shared_preference.dart';

class SignServices {
  static final FirebaseAuth mAuth = FirebaseAuth.instance;
  static final logger = LoggerService();
  final signUpController = Get.put(SignUpController());

   Future<void> mySignIn(String email, String password) async {
    try {
      Logger().d("Login Not");
      Get.defaultDialog(
        title: "Sign in",
        content: const Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
          ),
        ),
      );
 
      final userCredential = await mAuth.signInWithEmailAndPassword(
          email: email, password: password);
          Logger().d("Login successful");

      if (userCredential.user != null) {
        final UserPreference userPreference = UserPreference();
        String? userToken =
            await FirebaseAuth.instance.currentUser?.getIdToken();
        userPreference.saveUserToken(userToken!);
        debug("HomePage");
        Get.toNamed(RoutesName.homeScreen)!.then((value) {
          logger.logDebug("HomeView: " + value.toString());
        });
        logger.logDebug("going to HomePage");
      } else {
        Get.back();
        Get.defaultDialog(
          title: "Sign-in Failed",
          middleText:
              "Invalid email or password. Please check your credentials.",
          confirm: MyTextButton(
            text: "OK",
            onPressed: () {
              Get.back();
            },
          ),
        );
        logger.logDebug("Login Page");
      }
    } catch (error) {
      Get.back();
      if (error is FirebaseAuthException) {
        String errorMessage = "Sign in failed: ${error.message}";
        if (error.code == 'invalid-email' || error.code == 'wrong-password') {
          errorMessage =
              "Invalid email or password. Please check your credentials.";
        }

        Get.defaultDialog(
          title: "Sign-in Failed",
          middleText: errorMessage,
          confirm: MyTextButton(
            text: "OK",
            onPressed: () {
              Get.back();
            },
          ),
        );
        logger.logDebug("Login Page");
      } else {
        Utils.myBoxShow("Error", "Server Error");
        logger.logDebug("Login Page");
        debug(error.toString());
      }
    }
  }

  // GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<void> handleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final auth = await FirebaseAuth.instance.signInWithCredential(credential);

      print(auth.user?.displayName);
    } catch (error) {
      print('Google Sign-In Error: $error');
    }
  }
}

void debug(String message) {
  if (kDebugMode) print(message);
}
