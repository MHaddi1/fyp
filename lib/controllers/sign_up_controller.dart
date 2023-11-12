import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  final sigUpServices = SignUpServices();
  RxString email = ''.obs;
  RxString password = ''.obs;
  final _image = Rx<File?>(null);
  DateTime time = DateTime.now();
  RxInt type = 0.obs;
  RxString name = ''.obs;
  FirebaseAuth _authService = FirebaseAuth.instance;
  Rx<GetUserModel?> user = Rx<GetUserModel?>(null);

  // @override
  // void onInit() {
  //   super.onInit();
  //    user.bindStream(_authService.authStateChanges());
  // }

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

  void mySingUp() async {
    try {
      sigUpServices.signUp(myEmail.trim(), myPassword.trim()).then((value) {
        myData();
      });
    } catch (e) {
      print(e);
    }
  }

  forgetPassword() async {
    try {
      await sigUpServices.resetPassword(myEmail);
    } catch (e) {
      Utils.snackBar("error", e.toString());
    }
  }

  getMyLocation() async {
    try {
      await sigUpServices.currentCity();
    } catch (e) {
      Utils.snackBar("error", e.toString());
    }
  }

  Future<void> myData() async {
    String location = await sigUpServices.currentCity();

    GetUserModel userModel = GetUserModel(
      name: myName,
      email: myEmail,
      location: location,
      dateTime: time,
      image: image.toString(),
      type: 1,
    );

    try {
      await sigUpServices.userData(userModel).then((value) {
        Utils.snackBar("Add Data", "Data Add successfully");
        Get.offAndToNamed(RoutesName.signScreen);
      });
      await uploadImageToFirebaseStorage(_image.value!);
    } catch (e) {
      Utils.snackBar("error", e.toString());
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _image.value = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String location = await sigUpServices.currentCity();
      final storage = FirebaseStorage.instance;
      final storageRef = storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.png');
      await storageRef.putFile(imageFile);

      final String downloadURL = await storageRef.getDownloadURL();

      // Update the user model with the download URL
      GetUserModel userModel = GetUserModel(
        name: myName,
        email: myEmail,
        location: location,
        dateTime: time,
        image: downloadURL,
        type: 1,
      );

      print('Image uploaded to Firebase Storage. Download URL: $downloadURL');

      // Continue with saving user data using the updated user model
      await sigUpServices.updateUser(userModel).then((value) {
        Utils.snackBar("Update Data", "Data Update successfully");
      });
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
    }
  }
}
