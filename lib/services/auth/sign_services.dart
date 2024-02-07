import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/suggestions/my_text_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/logger.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';

import '../SharedPrefernece/shared_preference.dart';

class SignServices {
  static final FirebaseAuth mAuth = FirebaseAuth.instance;
  static final logger = LoggerService();
  final signUpController = Get.put(SignUpController());
  final SignUpServices signUpServices = SignUpServices();
  String time = DateTime.now().toString();

  Future<void> mySignIn(String email, String password) async {
    try {
      Get.dialog(
        Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );

      final UserCredential userCredential =
          await mAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? userToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      UserPreference().saveUserToken(userToken.toString());

      if (userCredential.user != null) {
        Get.back(); // Close the loading dialog

        bool userDataExists = await checkUserDataExists(userCredential.user!);

        if (!userDataExists) {
          await saveUserData(userCredential.user!);
        }
        // Navigate to the home screen
        Get.offNamed(RoutesName.homeScreen);
      } else {
        Get.back(); // Close the loading dialog
        Get.defaultDialog(
          title: "Sign-in Failed",
          middleText:
              "Invalid email or password. Please check your credentials.",
          confirm: TextButton(
            onPressed: () => Get.back(),
            child: Text("OK"),
          ),
        );
      }
    } catch (error) {
      Get.back(); // Close the loading dialog
      String errorMessage = "Sign in failed: $error";
      if (error is FirebaseAuthException) {
        if (error.code == 'invalid-email' || error.code == 'wrong-password') {
          errorMessage =
              "Invalid email or password. Please check your credentials.";
        }
      }
      Get.defaultDialog(
        title: "Sign-in Failed",
        middleText: errorMessage,
        confirm: TextButton(
          onPressed: () => Get.back(),
          child: Text("OK"),
        ),
      );
    }
  }

  Future<bool> checkUserDataExists(User user) async {
    // Check if user data exists in Firestore based on user ID or email
    // You can use user ID or email depending on how you store user data in Firestore
    // For example:
    // Query user data based on user ID
    // DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    // OR query user data based on email
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();
    return userData.exists;
  }

  Future<void> saveUserData(User user) async {
    // Extract user information
    String myEmail = user.email!;
    String location =
        await SignUpServices().currentCity(); // Provide user location
    String time = ''; // Provide user time
    String? image =
        'https://imgv3.fotor.com/images/blog-richtext-image/10-profile-picture-ideas-to-make-you-stand-out.jpg'; // Provide user image

    // Create UserModel object
    GetUserModel userModel = GetUserModel(
        name: myEmail.split("@")[0],
        email: myEmail.toLowerCase(),
        location: location,
        dateTime: time.toDate(),
        image: image,
        type: 1,
        bio: "Write The About You If Tailer Write Expertize",
        uid: mAuth.currentUser!.uid);

    // Save user data to Firestore
    await signUpServices.userData(userModel);
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
