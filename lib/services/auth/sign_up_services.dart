import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/views/auth/login_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SignUpServices {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> signUp(String email, String password) async {
    try {
      // Show signing up dialog
      Get.defaultDialog(
        backgroundColor: Colors.transparent,
        title: "Signing Up",
        content: const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Check if the user already exists
      var data = await FirebaseFirestore.instance.collection("users").get();
      bool userExists = false;
      for (var doc in data.docs) {
        if (email == doc['email']) {
          userExists = true;
          break;
        }
      }

      if (userExists) {
        // Get.back();
        Utils.showToastMessage("User Already Exists!!");
        return;
      }

      // Create a new user
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Send email verification
        await user.sendEmailVerification();

        // Set FCM token
        await setFCMToken();

        Get.back();

        Utils.snackBar(
            "Success", "Verification email sent. Please verify your email.");

        // Navigate to sign screen
        for (var docs in data.docs) {
          if (docs['type'] == 1)
            Get.offAndToNamed(RoutesName.signScreen);
          else if (docs['type'] == 2) Get.offAndToNamed(RoutesName.signScreen);
        }
      } else {
        Get.back();
        Utils.snackBar("Error", "Failed to sign up. Please try again.");
      }
    } catch (error) {
      Get.back(); // Ensure the dialog is dismissed in case of an error
      if (error is FirebaseAuthException) {
        String errorMessage;
        switch (error.code) {
          case 'email-already-in-use':
            errorMessage = "The email is already in use by another account.";
            break;
          case 'invalid-email':
            errorMessage = "The email address is not valid.";
            break;
          case 'operation-not-allowed':
            errorMessage = "Email/password accounts are not enabled.";
            break;
          case 'weak-password':
            errorMessage = "The password is too weak.";
            break;
          default:
            errorMessage = "An error occurred: ${error.message}";
            break;
        }
        Utils.snackBar("Error", errorMessage);
      } else {
        Utils.snackBar(
            "Error", "An unexpected error occurred. Please try again.");
      }
    } finally {
      Get.back();
    }
  }

  // Future<void> signUp(String email, String password) async {
  //   try {
  //     Get.defaultDialog(
  //       title: "Signing Up",
  //       content: const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //     var data = await FirebaseFirestore.instance.collection("users").get();
  //     for (var docs in data.docs) {
  //       if (email == docs['email']) {
  //         await FirebaseAuth.instance
  //             .createUserWithEmailAndPassword(email: email, password: password);
  //       } else {
  //         Utils.showToastMessage("User Already Exist!!");
  //       }
  //     }
  //
  //     User? user = FirebaseAuth.instance.currentUser;
  //
  //     if (user != null) {
  //       await user.sendEmailVerification();
  //
  //       await setFCMToken();
  //
  //       Get.back();
  //
  //       Utils.snackBar(
  //           "Success", "Verification email sent. Please verify your email.");
  //
  //       Get.offAndToNamed(RoutesName.signScreen);
  //     } else {
  //       Get.back();
  //       Utils.snackBar("Error", "Failed to sign up. Please try again.");
  //     }
  //   } catch (error) {
  //     if (error is FirebaseAuthException) {
  //       // Handle specific FirebaseAuthException errors if needed.
  //     } else {
  //       Get.defaultDialog(
  //         title: "Error",
  //         content: const Text("An unexpected error occurred"),
  //         onConfirm: () {
  //           Get.back();
  //         },
  //       );
  //     }
  //   }
  // }

  bool isEmailVerified() {
    User? currentUser = _authService.currentUser;
    return currentUser != null && currentUser.emailVerified;
  }
  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      // Query Firestore to find the user with the provided email
      var querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // User with the provided email does not exist
        Utils.showToastMessage("User Not Found");
        print("User with email $email not found");
      } else {
        // User found, send password reset email
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Get.offAll(() => SignView()); // Navigate to SignView using GetX
        Utils.showToastMessage("Check your inbox for password reset instructions");
      }
    } on FirebaseException catch (e) {
      // Handle Firebase exceptions
      Utils.showToastMessage("Failed to send password reset email: ${e.message}");
      print("FirebaseException: ${e.message}");
    } catch (e) {
      // Handle other exceptions
      Utils.showToastMessage("Error: $e");
      print("Error: $e");
    }
  }
  // Future<void> sendPasswordResetEmail(
  //     BuildContext context, String email) async {
  //   try {
  //     var data = await FirebaseFirestore.instance.collection("users").get();
  //     for (var docs in data.docs) {
  //       print(docs['email']);
  //       if (email == docs['email']) {
  //         await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //         Get.offAll(() => SignView());
  //         Utils.showToastMessage("Check your Inbox For mail");
  //       } else {
  //         Utils.showToastMessage("User Not Found");
  //         print("Email is Not Found");
  //       }
  //     }
  //
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Password reset email sent')),
  //     // );
  //   } on FirebaseAuthException catch (e) {
  //     Utils.showToastMessage(e.toString());
  //     print(e);
  //   }
  // }

  // Future<void> resetPassword(String email) async {
  //   try {
  //     Get.defaultDialog(
  //       title: "Resetting Password",
  //       content: const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //
  //     await _authService.sendPasswordResetEmail(email: email);
  //     Get.back(); // Close the dialog
  //     Utils.snackBar("Success", "Password reset email sent.");
  //     Get.to(() => SignView()); // Navigate to SignInView only if email exists
  //   } on FirebaseAuthException catch (e) {
  //     Get.back(); // Close the dialog in case of an error
  //     if (e.code == 'user-not-found') {
  //       Utils.snackBar("Error", "No user found for that email.");
  //     } else if (e.code == 'invalid-email') {
  //       Utils.snackBar("Error", "Invalid email address.");
  //     } else if (e.code == 'too-many-requests') {
  //       Utils.snackBar("Error", "Too many requests. Try again later.");
  //     } else {
  //       Utils.snackBar("Error", e.message ?? "An unknown error occurred.");
  //       debugPrint(e.toString());
  //     }
  //   } catch (e) {
  //     Get.back(); // Close the dialog in case of an unknown error
  //     debugPrint('Error: $e');
  //     Utils.snackBar("Error", "An unknown error occurred.");
  //   }
  // }

  // Future<void> resetPassword(String email) async {
  //   try {
  //     Get.defaultDialog(
  //       title: "Resetting Password",
  //       content: const Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //     await _authService.sendPasswordResetEmail(email: email).then((value){
  //       Get.to(() => SignView());
  //     });
  //     Get.back();
  //     Utils.snackBar("Success", "Password reset email sent.");
  //
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       Utils.snackBar("Error", "No user found for that email.");
  //     } else {
  //       Utils.snackBar("Error", e.toString());
  //       debug(e.toString());
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     debug(e.toString());
  //     Utils.snackBar("Error", e.toString());
  //   }
  // }

  Future<void> userData(GetUserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(_authService.currentUser!.email)
          .set(userModel.toJson());
      SetOptions(merge: true);
    } catch (e) {
      print('Error: $e');
      debug(e.toString());
      Utils.snackBar("Error", e.toString());
    }
  }

  Future<void> updateUser(GetUserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(_authService.currentUser!.email)
          .update(userModel.toJson());
    } catch (e) {
      debug(e.toString());
    }
  }

  Future<String> currentCity() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String? cityName = placemark[0].locality;

    return cityName ?? "";
  }

  debug(String message) {
    if (kDebugMode) print(message);
  }

  Future<void> setFCMToken() async {
    String? fcmToken = await _firebaseMessaging.getToken();
    if (fcmToken != null) {
      await _firestore
          .collection("user")
          .doc(_authService.currentUser!.uid)
          .set({
        'fcmToken': fcmToken,
      }, SetOptions(merge: true));
    }
  }
}
