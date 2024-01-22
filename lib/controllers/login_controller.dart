import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:fyp/services/auth/sign_services.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/logger.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  RxBool ispassword = true.obs;
  RxBool isLoading = false.obs;
  LoggerService loggerService = LoggerService();
  UserPreference userPreference = UserPreference();
  RxString email = "".obs;
  RxString password = "".obs;
  final SignServices signServices = SignServices();

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

  Future<UserCredential> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // The user canceled the sign-in process
        throw Exception("Google Sign-In was canceled");
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      // Handle specific exceptions
      if (e is FirebaseAuthException) {
        // Firebase authentication-related errors
        debug("Firebase Auth Error: ${e.message}");
      } else if (e is GoogleSignInAccount) {
        // Google Sign-In errors
        debug("Google Sign-In Error: $e");
      } else {
        // Other unhandled exceptions
        debug("Unexpected Error: $e");
      }

      // Rethrow the exception after handling
      throw e;
    }
  }
}
