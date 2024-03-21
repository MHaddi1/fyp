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
import 'package:fyp/views/chat_view.dart';
import 'package:fyp/views/home/screens/profile_screen.dart';
import 'package:fyp/views/tailors_data_entry.dart';
import 'package:fyp/views/tailors_data_entry2.dart';
import 'package:fyp/views/view_orders.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../views/home/screens/search_screen.dart';
import 'camera_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
    EasyLoading.show(
        dismissOnTap: true,
        status: "Profile change",
        indicator: CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.black);
    int? userType = await change.getType();
    print("User type: $userType");
    if (userType == 2 || userType == 1) {
      change.changeProfileType();
      print("Profile type changed successfully");
    }
    EasyLoading.dismiss();
  }

  Future<String?> image(User? user) async {
    final myimage = await change.getImageUrl(user!.email!);
    return myimage;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: mainBack,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: mainColor,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FutureBuilder<String?>(
                        future: image(user),
                        builder: (context, snapshot) {
                          String? imageUrl = snapshot.data;
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError ||
                              snapshot.data == null) {
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
                              backgroundImage:
                                  CachedNetworkImageProvider(imageUrl!),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10),
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: FutureBuilder<int?>(
                      future: change.getType(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.hasError ||
                            snapshot.data == null) {
                          return SizedBox();
                        } else {
                          return Text(
                            snapshot.data == 2 ? "Tailor" : "Customer",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                MyListTitle(
                    icon: Icons.change_circle,
                    text: "Change Profile",
                    onPressed: () async {
                      Get.back();
                      User? user = FirebaseAuth.instance.currentUser;
                      bool phoneNoExists =
                          await change.checkUserDataExists(user!);

                      if (phoneNoExists) {
                        confirmChange();
                      } else {
                        //bool switchValue = false;
                        await Get.defaultDialog(
                          title: "Add Phone Number",
                          middleText: "",
                          actions: [
                            Row(
                              children: [
                                // Text("Switch Text"),
                                // Switch(
                                //   value: switchValue,
                                //   onChanged: (value) {
                                //     switchValue = value;
                                //   },
                                // ),
                              ],
                            ),
                            InternationalPhoneNumberInput(
                              textFieldController: _phoneNumber,
                              onInputChanged: (PhoneNumber number) {
                                phone = number.phoneNumber.toString();
                              },
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DROPDOWN,
                              ),
                              countries: ['PK'],
                              errorMessage: 'Invalid phone number',
                            ),
                          ],
                          confirm: MyButton(
                            text: "Continue",
                            onPressed: () async {
                              User? user = FirebaseAuth.instance.currentUser;
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
                          ),
                        );
                      }
                    }),
                const Divider(),
                // MyListTitle(
                //     icon: Icons.home,
                //     text: "Home",
                //     onPressed: () {
                //       Get.to(() => SearchScreen());
                //     }),
                // const Divider(),
                // MyListTitle(
                //   icon: Icons.announcement_sharp,
                //   text: "Announcement",
                //   onPressed: () {
                //     //Get.back();
                //     Get.toNamed(RoutesName.homeScreen);
                //   },
                // ),
                // const Divider(),
                // MyListTitle(
                //   icon: Icons.person,
                //   text: "Profile",
                //   onPressed: () {
                //     Get.back();
                //     Get.to(() => ProfileScreen());
                //   },
                // ),
                //const Divider(),
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
                        return Column(
                          children: [
                            MyListTitle(
                              icon: Icons.camera,
                              text: "Measurement",
                              onPressed: () {
                                Get.back();
                                Get.to(() => const Measurement());
                              },
                            ),
                            const Divider(),
                            MyListTitle(
                                color: textWhite,
                                scr: "assets/image/chat_bot.png",
                                text: "Chat Bot",
                                onPressed: () {
                                  Get.to(() => ChatView(
                                        chatType: "bot",
                                      ));
                                })
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            MyListTitle(
                                icon: Icons.post_add,
                                text: "TPost",
                                onPressed: () {
                                  Get.to(() => TailorDataEntry());
                                }),
                            const Divider(),
                            MyListTitle(
                              text: "Orders",
                              onPressed: () {
                                Get.to(() => ViewOrders(
                                    uid: FirebaseAuth
                                        .instance.currentUser!.uid));
                              },
                              scr: "assets/image/orders.png",
                            )
                          ],
                        );
                      }
                    }
                  },
                ),
                const Divider(),
              ],
            ),
            MyListTitle(
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
          ],
        ),
      ),
    );
  }
}
