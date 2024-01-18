import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/controllers/profile_controller.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/models/get_user_model.dart';
import 'package:fyp/services/auth/sign_up_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../const/components/my_text_box.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _profileController = Get.put(ProfileController());
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection("users");
  final _signUpController = Get.put(SignUpController());

  String _formatDate(DateTime dateTime) {
    String formattedDate = DateFormat.yMMMd().format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection
            .doc(currentUser!.email ?? "youName@example.com")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            DateTime datetime = DateTime.parse(userData['dateTime']);

            return Container(
              padding: const EdgeInsets.all(10),
              color: mainBack,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      VStack([
                        10.heightBox,
                        GestureDetector(
                          onTap: () async {
                            _signUpController.pickImage(ImageSource.gallery);
                          },
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: mainColor,
                            backgroundImage: CachedNetworkImageProvider(userData[
                                    'image'] ??
                                "https://cdn-icons-png.flaticon.com/512/2815/2815428.png"),
                          )
                              .box
                              .border(color: Colors.black, width: 5)
                              .roundedFull
                              .alignCenter
                              .make(),
                        ),
                        10.heightBox,
                        currentUser != null
                            ? currentUser!.email!.text.xl.bold
                                .color(textWhite)
                                .make()
                                .box
                                .alignCenter
                                .make()
                            : "Your Email"
                                .text
                                .color(textWhite)
                                .xl
                                .bold
                                .make()
                                .box
                                .alignCenter
                                .make(),
                        10.heightBox,
                        GestureDetector(
                            onTap: () => editBio("bio"),
                            child: "Edit Bio"
                                .text
                                .color(textWhite)
                                .underline
                                .bold
                                .make()
                                .box
                                .alignCenter
                                .make()),
                        userData['bio'] != null
                            ? userData['bio']
                                .toString()
                                .text
                                .justify
                                .color(textWhite)
                                .make()
                                .box
                                .alignCenter
                                .p24
                                .make()
                            : "Your Bio"
                                .text
                                .justify
                                .color(textWhite)
                                .make()
                                .box
                                .alignCenter
                                .p24
                                .make()
                      ])
                          .box
                          .shadow
                          .color(postBlock)
                          .roundedLg
                          .make()
                          .px12()
                          .py16(),
                      10.heightBox,
                      "Details"
                          .text
                          .xl3
                          .bold
                          .color(textWhite)
                          .make()
                          .px16()
                          .box
                          .alignTopLeft
                          .make(),
                      Column(
                        children: [
                          MyTextBox(
                            text: "Name",
                            yourName: userData["name"] != null
                                ? userData['name'].toString()
                                : "Your Name",
                            onPressed: () => editField("name"),
                            icon: Icons.settings,
                          ),
                          20.heightBox,
                          MyTextBox(
                            text: "Location",
                            yourName: userData['location'] != null
                                ? userData['location'].toString()
                                : "Your Location",
                            onPressed: () => editField("location"),
                            icon: Icons.settings,
                          ),
                          20.heightBox,
                          MyTextBox(
                              text: "Joined",
                              // ignore: unnecessary_null_comparison
                              yourName: datetime != null
                                  ? _formatDate(datetime)
                                  : "Your Date",
                              onPressed: () {})
                        ],
                      )
                          .box
                          .shadow
                          .color(postBlock)
                          .p16
                          .roundedSM
                          .make()
                          .px8()
                          .py16(),
                    ],
                  ).box.shadowSm.color(mainBack).roundedSM.make(),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  // The method to edit the field (name in this case)
  editField(String field) {
    String newValue = "";
    Get.defaultDialog(
      backgroundColor: Colors.black,
      titleStyle: TextStyle(color: Colors.white),
      title: "Edit $field",
      content: TextField(
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter New $field",
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        onChanged: (value) {
          newValue = value;
        },
      ),
      onConfirm: () async {
        Get.back(result: newValue);

        if (newValue.trim().isNotEmpty) {
          try {
            await userCollection
                .doc(currentUser!.email)
                .update({field: newValue});
          } catch (e) {
            // Handle the error
            print("Error updating user document: $e");
          }
        }
      },
      onCancel: () {
        //Get.back();
      },
    );
  }

  editBio(String value) {
    String newValue = "";
    Get.bottomSheet(Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextField(
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Bio",
          ),
          onChanged: (value) {
            newValue = value;
          },
        ).p16(),
        30.heightBox,
        MyButton(
          text: "Update Bio",
          onPressed: () async {
            if (newValue.trim().isNotEmpty) {
              try {
                Get.back(result: newValue);
                await userCollection
                    .doc(currentUser!.email)
                    .update({value: newValue});
              } catch (e) {
                Logger().e(e.toString());
              }
            }
          },
        ).py16()
      ],
    ).box.shadow.color(Colors.white).size(Get.width, Get.height * 0.5).make());
  }
}
