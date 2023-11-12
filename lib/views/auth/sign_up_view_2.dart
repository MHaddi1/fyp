import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_icons.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final _nameController = TextEditingController();
  final _signUpController = Get.put(SignUpController());
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => Stack(
                      alignment: Alignment(0.6, 1),
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.orange,
                          backgroundImage: _signUpController.image != null
                              ? Image.file(_signUpController.image!).image
                              : CachedNetworkImageProvider(
                                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80',
                                ),
                        )
                            .box
                            .roundedFull
                            .border(color: Colors.orange, width: 15)
                            .make(),
                        IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 50,
                          ),
                          onPressed: () {
                            Get.bottomSheet(
                              Column(
                                children: [
                                  MyIcons(
                                    icon: Icons.camera,
                                    size: 40,
                                    text: 'Camera',
                                    onTap: () {
                                      _signUpController
                                          .pickImage(ImageSource.camera);
                                    },
                                  ),
                                  MyIcons(
                                    icon: Icons.image,
                                    size: 40,
                                    text: 'Gallery',
                                    onTap: () {
                                      _signUpController
                                          .pickImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              )
                                  .box
                                  .size(Get.width, Get.height * 0.4)
                                  .color(Colors.white)
                                  .topRounded()
                                  .make(),
                            );
                          },
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  20.heightBox,
                  MyField(
                    onChanged: (value) {
                      _signUpController.setName(value!);
                    },
                    controller: _nameController,
                    text: "Name",
                    validate: (value) {
                      if (value!.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                  ),
                  10.heightBox,
                  MyIcons(
                    text: "Get Location",
                    icon: Icons.place,
                    onTap: () {
                      _signUpController.getMyLocation();
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    width: Get.width,
                    text: "Continue",
                    onPressed: () {
                      _signUpController.mySingUp();
                    },
                  ),
                ],
              ).box.make().p16(),
            ),
          ),
        ],
      ).py20(),
    );
  }
}
