import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/views/home/home_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignServices {
  static final FirebaseAuth mAuth = FirebaseAuth.instance;

  static Future<void> mySignIn(String email, String password) async {
    try {
      Get.defaultDialog(
          title: "Sign in",
          content: const Center(
            child: CircularProgressIndicator(),
          ));
      await mAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        debug(value.toString());
        Get.back();
        Get.to(() => const HomeView());
      });
    } catch (e) {
      debug(e.toString());
    }
  }

  //final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  handleSignIn() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (error) {
      if (error is PlatformException) {
        debug(error.toString());
      } else {
        debug(error.toString());
      }
    }
  }
}

void debug(String message) {
  if (kDebugMode) print(message);
}
