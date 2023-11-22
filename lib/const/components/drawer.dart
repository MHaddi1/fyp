import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/components/chat_persons.dart';
import 'package:fyp/const/components/list_title.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/home_controller.dart';
import 'package:fyp/main.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:fyp/views/auth/login_view.dart';
import 'package:fyp/views/camera_view.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'camera_view.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.amber,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(FirebaseAuth
                          .instance.currentUser?.photoURL ??
                      "https://cdn-icons-png.flaticon.com/512/2815/2815428.png"),
                ),
                10.heightBox,
                Text(
                  FirebaseAuth.instance.currentUser?.email ??
                      "Please Login The Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                MyListTitle(
                  icon: Icons.home,
                  text: "Home",
                  onPressed: () {
                    Get.back();
                  },
                ),
                const Divider(),
                MyListTitle(
                  icon: Icons.person,
                  text: "Profile",
                  onPressed: () {
                    Get.back();
                    Get.to(() => ProfileScreen());
                  },
                ),
                const Divider(),
                MyListTitle(
                    icon: Icons.chat_bubble,
                    text: "Customer Support",
                    onPressed: () {
                      Get.back();
                      Get.to(() => const ChatPerson());
                    }),
                const Divider(),
                MyListTitle(
                    icon: Icons.camera,
                    text: "Measurement",
                    onPressed: () {
                      Get.back();
                      Get.to(() => const Measurement());
                    })
                // Add more ListTitle widgets for additional items in the drawer
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: MyListTitle(
              icon: Icons.logout,
              text: "Logout",
              onPressed: () {
                UserPreference().clearUserToken();
                Get.back();
                Get.offAndToNamed(RoutesName.signScreen);
              },
            ),
          ),
        ],
      ),
    );
  }
}
