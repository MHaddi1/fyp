import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:fyp/services/sign_services.dart';
import 'package:fyp/utils/logger.dart';
import 'package:fyp/utils/utils.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool ispassword = true.obs;
  RxBool isLoading = false.obs;
  LoggerService loggerService = LoggerService();
  UserPreference userPreference = UserPreference();
  RxString email = "".obs;
  RxString password = "".obs;
  final SignServices signServices = SignServices();

  void setEmail(String value) {
    email.value = value;
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
      isLoading.value = true;
      final UserPreference userPreference = UserPreference();
      String? userToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      await SignServices.mySignIn(getEmail, getPassword).then((value) {
        userPreference.saveUserToken(userToken!);
        loggerService.logInfo("Successfully Logged in");
      });
    } catch (e) {
      Utils.myBoxShow("title", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleSignIn() async {
    try {
      final UserPreference userPreference = UserPreference();
      String? userToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      userPreference.saveUserToken(userToken!);
      await signServices.handleSignIn();

      loggerService.logInfo("Successfully Logged in");
    } catch (e) {
      debug(e.toString());
    }
  }
}
