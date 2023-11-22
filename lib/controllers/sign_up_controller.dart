import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  final SignUpServices signUpServices = SignUpServices();
  final FirebaseAuth _authService = FirebaseAuth.instance;

  RxString email = ''.obs;
  RxString password = ''.obs;
  final _image = Rx<File?>(null);
  DateTime time = DateTime.now();
  RxInt type = 0.obs;
  RxString name = ''.obs;
  Rx<GetUserModel?> user = Rx<GetUserModel?>(null);

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  void setProfile(File value) {
    _image.value = value;
  }

  void setType(int value) {
    type.value = value;
  }

  void setName(String value) {
    name.value = value;
  }

  String get myEmail => email.value;
  String get myPassword => password.value;
  File? get image => _image.value;
  int get myType => type.value;
  String get myName => name.value;

  void mySignUp() async {
    try {
      await signUpServices.signUp(myEmail.trim(), myPassword.trim());
      GetUserModel userModel = GetUserModel(
        name: myEmail.split("@")[0],
        email: myEmail,
        type: 1,
        location: await SignUpServices().currentCity(),
        dateTime: DateTime.now(),
        bio: "Write You Bio",
        uid: FirebaseAuth.instance.currentUser?.uid,
        
      );
      await signUpServices.userData(userModel);
    } catch (e) {
      print('Error signing up: $e');
    }
  }

  void forgetPassword() async {
    try {
      await signUpServices.resetPassword(myEmail);
    } catch (e) {
      Utils.snackBar("Error", e.toString());
    }
  }

  Future<void> myData() async {
    Get.defaultDialog(
      title: "Sign Up",
      content: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      String location = await signUpServices.currentCity();
      GetUserModel userModel = GetUserModel(
        name: myEmail.split("@")[0],
        email: myEmail,
        location: location,
        dateTime: time,
        image: image?.toString() ?? '',
        type: 1,
      );

      await signUpServices.userData(userModel);
      await uploadImageToFirebaseStorage(image!);
      Utils.snackBar("Add Data", "Data Add successfully");
      Get.offAndToNamed(RoutesName.signScreen);
    } catch (e) {
      Utils.snackBar("Error", e.toString());
    } finally {
      Get.back();
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
      await uploadImageToFirebaseStorage(File(pickedFile.path));
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String location = await signUpServices.currentCity();
      final storage = FirebaseStorage.instance;
      final storageRef = storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.png');
      await storageRef.putFile(imageFile);
      final String downloadURL = await storageRef.getDownloadURL();

      GetUserModel userModel = GetUserModel(
        name: _authService.currentUser?.email!.split("@")[0],
        email: _authService.currentUser?.email ?? '',
        location: location,
        dateTime: time,
        image: downloadURL,
        type: 1,
        bio: "Write You Bio",
      );

      await signUpServices.updateUser(userModel);
      Utils.snackBar("Update Data", "Data Update successfully");
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }
}
