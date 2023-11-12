import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/profile_services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ProfileController extends GetxController {
  final profileServices = ProfileServices();
  final users = <GetUserModel>[].obs;
  final logger = Logger();
  @override
  void onInit() {
    super.onInit();
    displayMyProfile();
  }

  displayMyProfile() async {
    try {
      final myUser = await profileServices.displayUser();
      users.addAll(myUser);
      logger.i(users.toString());
    } catch (e) {
      logger.d(e.toString());
    }
  }
}
