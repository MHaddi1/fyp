import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:get/get.dart';
import 'package:fyp/services/profile_services.dart';
import 'package:fyp/models/get_user_model.dart';

class ProfileController extends GetxController {
  var users = <GetUserModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    fetchUser();
  }

  void fetchUser() async {
    try {
      isLoading(true);
      List<GetUserModel> userResult = await ProfileServices().displayUser();
      users.assignAll(userResult);
    } catch (error) {
      print("Error fetching user: $error");
    } finally {
      isLoading(false);
    }
  }

  void updateName() async {
    var nameUpdate = GetUserModel(
        name: "Muhammad Haddi",
        email: FirebaseAuth.instance.currentUser!.email);
    try {
      isLoading(true);
      await SignUpServices().updateUser(nameUpdate);
    } catch (error) {
      print("Error updating name: $error");
    } finally {
      isLoading(false);
    }
  }
}
