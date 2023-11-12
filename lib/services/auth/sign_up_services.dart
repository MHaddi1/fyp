import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/utils/utils.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class SignUpServices {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp(String email, String password) async {
    try {
      Get.defaultDialog(
        title: "Signing Up",
        content: const Center(
          child: CircularProgressIndicator(),
        ),
      );

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.sendEmailVerification();

        Get.back();

        Utils.snackBar(
            "Success", "Verification email sent. Please verify your email.");

        Get.offAndToNamed(RoutesName.signScreen);
      } else {
        Get.back();
        Utils.snackBar("Error", "Failed to sign up. Please try again.");
      }
    } catch (error) {
      if (error is FirebaseAuthException) {
        // Handle specific FirebaseAuthException errors if needed.
      } else {
        Get.defaultDialog(
          title: "Error",
          content: const Text("An unexpected error occurred"),
          onConfirm: () {
            Get.back();
          },
        );
      }
    }
  }

  bool isEmailVerified() {
    User? currentUser = _authService.currentUser;
    return currentUser != null && currentUser.emailVerified;
  }

  Future<void> resetPassword(String email) async {
    try {
      Get.defaultDialog(
        title: "Resetting Password",
        content: const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _authService.sendPasswordResetEmail(email: email);
      Get.back();
      Utils.snackBar("Success", "Password reset email sent.");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.snackBar("Error", "No user found for that email.");
      } else {
        Utils.snackBar("Error", e.toString());
        debug(e.toString());
      }
    } catch (e) {
      print('Error: $e');
      debug(e.toString());
      Utils.snackBar("Error", e.toString());
    }
  }

  Future<void> userData(GetUserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(_authService.currentUser!.uid)
          .set(userModel.toJson());
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
          .doc(_authService.currentUser!.uid)
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
}
