import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_icons.dart';
import 'package:get/get.dart';
import 'package:fyp/controllers/profile_controller.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final pref = UserPreference();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Obx(() {
          if (_profileController.users.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: _profileController.users
                  .where(
                      (user) => user.email == firebaseAuth.currentUser?.email)
                  .map((user) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: CachedNetworkImageProvider(
                              user.image ??
                                  "https://yt3.googleusercontent.com/-H4bsnS3lUHCiaDtVcHxm9dJudoCyLdjnBCaIJZSsMJPNqIJFZFqs5iaTx0OjZcxwwCxycfEnA=s900-c-k-c0x00ffffff-no-rj",
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Welcome back!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "Hello, ${user.name ?? "Anonymous"}!",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Email:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.email ?? "Email not found",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                "Location:".text.xl.bold.make(),
                                user.location!.text.make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pref
              .clearUserToken()
              .then((value) => Get.offAndToNamed(RoutesName.signScreen));
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
