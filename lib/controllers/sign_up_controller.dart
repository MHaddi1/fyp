import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final sigUpServices = SignUpServices();
  RxString email = ''.obs;
  RxString password = ''.obs;
  FirebaseAuth _authService = FirebaseAuth.instance;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.authStateChanges());
  }

  void setEmail(String value) {
    email.value = value;
  }

  void setPassword(String value) {
    password.value = value;
  }

  String get myEmail => email.value;
  String get myPassword => password.value;

  void mySingUp() async {
    try {
      sigUpServices.signUp(myEmail.trim(), myPassword.trim());
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
}
