import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:get/get.dart';
import 'SharedPrefernece/shared_preference.dart';

class SplashServices {
  void isLogin() {
    final UserPreference userPreference = UserPreference();
    userPreference.getUserToken().then((token) {
      if (kDebugMode) {
        print(token);
      }
      if (token == null) {
        Timer(const Duration(seconds: 3),
            () => Get.toNamed(RoutesName.suggestionScreen));
      } else {
        Timer(const Duration(seconds: 3),
            () => Get.toNamed(RoutesName.homeScreen));
        //Timer(const Duration(seconds: 3), () => Get.to(() => SearchScreen()));
      }
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error.toString());
      }
    });
  }
}
