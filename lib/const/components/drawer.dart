import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/chat_persons.dart';
import 'package:fyp/const/components/list_title.dart';
import 'package:fyp/const/components/login/bottom_sheet.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/home_controller.dart';
import 'package:fyp/main.dart';
import 'package:fyp/services/SharedPrefernece/shared_preference.dart';
import 'package:fyp/services/changeProfile.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/views/auth/login_view.dart';
import 'package:fyp/views/camera_view.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import 'camera_view.dart';

enum Gender { Male, Female }

class MyDrawer extends StatefulWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Gender? _selectedGender;
  final HomeController homeController = Get.put(HomeController());
  final _phoneNumber = TextEditingController();
  // final UserServices _userServices = UserServices();
  final change = ChangeProfile();
  String phone = "";
  User user = FirebaseAuth.instance.currentUser!;

  Future confirmChange() async {
    int? userType = await change.getType();
    print("User type: $userType");
    if (userType == 2 || userType == 1) {
      change.changeProfileType();
      print("Profile type changed successfully");
    }
  }

  Future<String?> image(User? user) async {
    final myimage = await change.getImageUrl(user!.email!);
    return myimage;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: mainBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: mainColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<String?>(
                  future: image(user),
                  builder: (context, snapshot) {
                    String? imageUrl = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show a loading indicator while fetching the image URL
                    } else if (snapshot.hasError || snapshot.data == null) {
                      print("image error: ${snapshot.error}r");
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: CachedNetworkImageProvider(
                          FirebaseAuth.instance.currentUser?.photoURL ??
                              "https://cdn-icons-png.flaticon.com/512/2815/2815428.png",
                        ),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: CachedNetworkImageProvider(imageUrl!),
                      );
                    }
                  },
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
                    icon: Icons.change_circle,
                    text: "Change Profile",
                    onPressed: () async {
                      Get.back();
                      User? user = FirebaseAuth.instance.currentUser;
                      bool phoneNoExists =
                          await change.checkUserDataExists(user!);
                      phoneNoExists
                          ? confirmChange()
                          : Get.defaultDialog(
                              title: "",
                              middleText: "",
                              actions: [
                                MyField(
                                  controller: _phoneNumber,
                                  text: "Phone Number",
                                  validate: (value) => null,
                                  onChanged: (value) {
                                    phone = value!;
                                  },
                                ),
                              ],
                              confirm: MyButton(
                                text: "Continue",
                                onPressed: () async {
                                  User? user =
                                      FirebaseAuth.instance.currentUser;
                                  if (user != null) {
                                    bool phoneNoExists =
                                        await change.checkUserDataExists(user);
                                    if (!phoneNoExists) {
                                      if (phone.isNotEmpty) {
                                        change.changeProfilePhone(phone);
                                      } else {
                                        Utils.showToastMessage(
                                            "Enter phone number");
                                      }
                                      Get.back();
                                    } else {
                                      change.changeProfileType();
                                    }
                                  }
                                },
                              ));
                    }),
                const Divider(),
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
                FutureBuilder<int?>(
                  future: change.getType(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return SizedBox();
                    } else {
                      if (snapshot.data == 1) {
                        return MyListTitle(
                          icon: Icons.camera,
                          text: "Measurement",
                          onPressed: () {
                            Get.back();
                            Get.to(() => const Measurement());
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    }
                  },
                ),
                // Add more ListTitle widgets for additional items in the drawer
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: MyListTitle(
              icon: Icons.logout,
              text: "Logout",
              onPressed: () async {
                Get.back();
                UserPreference().clearUserToken();
                await Get.offNamed(
                  RoutesName.suggestionScreen,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
