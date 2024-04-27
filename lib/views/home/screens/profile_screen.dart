import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/services/changeProfile.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  // final ProfileController _profileController = Get.put(ProfileController());
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
      // appBar: AppBar(
      //   centerTitle: true,
      //   leading: InkWell(
      //     onTap: () {
      //       Get.back();
      //     },
      //     child: Container(
      //       decoration: BoxDecoration(
      //           color: textWhite, borderRadius: BorderRadius.circular(12.0)),
      //       margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      //       padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      //       child: Icon(Icons.arrow_back),
      //     ),
      //   ),
      //   backgroundColor: mainBack,
      //   elevation: 0,
      //   title: const Text(
      //     'Profile',
      //     style: GoogleFonts.poppins(color: Colors.white),
      //   ),
      // ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(currentUser!.email!).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            DateTime datetime = DateTime.parse(userData['dateTime']);

            return Container(
              padding: const EdgeInsets.all(20),
              color: mainBack,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _signUpController.pickImage(ImageSource.gallery);
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: mainColor,
                        backgroundImage: CachedNetworkImageProvider(
                          userData['image'] ??
                              "https://cdn-icons-png.flaticon.com/512/2815/2815428.png",
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      currentUser!.email!,
                      style: GoogleFonts.poppins(
                        color: textWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => editBio("bio"),
                      child: Text(
                        "Edit Bio",
                        style: GoogleFonts.poppins(
                          color: textWhite,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: userData['bio'] != null
                          ? Text(
                              userData['bio'].toString(),
                              style: GoogleFonts.poppins(
                                color: textWhite,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Your Bio",
                              style: GoogleFonts.poppins(
                                color: textWhite,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Details',
                      style: GoogleFonts.poppins(
                        color: textWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyTextBox(
                      text: "Name",
                      yourName: userData["name"] != null
                          ? userData['name'].toString()
                          : "Your Name",
                      onPressed: () => editField("name"),
                      icon: Icons.settings,
                    ),
                    const SizedBox(height: 20),
                    //editField("location")
                    MyTextBox(
                      text: "Location",
                      yourName: userData['location'] != null
                          ? userData['location'].toString()
                          : "Your Location",
                      onPressed: () => null,
                      icon: Icons.settings,
                    ),
                    const SizedBox(height: 20),
                    MyTextBox(
                      text: "Joined",
                      yourName: datetime != null
                          ? _formatDate(datetime)
                          : "Your Date",
                      onPressed: () {},
                    ),
                    const SizedBox(height: 20),
                  ],
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
      titleStyle: GoogleFonts.poppins(color: Colors.white),
      title: "Edit $field",
      content: TextField(
        autofocus: true,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter New $field",
          hintStyle: GoogleFonts.poppins(color: Colors.grey),
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
                .update({field: newValue}).then((value) async {
              int? length = await ChangeProfile().getUserEmailIndex();
              print(length);
              final email =
                  await ChangeProfile().getUserEmailsFromIndex(length!);
              print("All Email $email");
              await ChangeProfile().updateUserName(email, newValue);
            });
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
