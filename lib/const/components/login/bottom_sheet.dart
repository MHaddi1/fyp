import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/const/components/social_media_button.dart';
import 'package:fyp/const/components/suggestions/my_text_button.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBottomLoginSheet extends StatelessWidget {
  const MyBottomLoginSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return SafeArea(
      top: false,
      bottom: false,
      child: Expanded(
        flex: 1,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                20.heightBox,
               
                "A²RI Craft".text.bold.xl3.make().box.alignBottomLeft.make(),
                20.heightBox,
                "Welcome Back!"
                    .text
                    .xl2
                    .bold
                    .make()
                    .animatedBox
                    .alignBottomLeft
                    .make(),
                20.heightBox,
                "We welcome you into our A²RI Craft to build your carior!"
                    .text
                    .xl
                    .make()
                    .animatedBox
                    .alignBottomLeft
                    .make(),
                30.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SocialMedia(
                        color: Colors.grey[200],
                        width: 50,
                        height: 30,
                        text: "Facebook",
                        image: const DecorationImage(
                            image: AssetImage(AppImage.facebook))),
                    SocialMedia(
                        color: Colors.grey[200],
                        width: 50,
                        height: 30,
                        text: "Google",
                        image: const DecorationImage(
                            image: AssetImage(AppImage.google))),
                  ],
                ),
                30.heightBox,
                const Text(
                  "or sign in with email",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                20.heightBox,
                Container(
                  color: Colors.white,
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: key,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          MyField(
                            textInputType: TextInputType.emailAddress,
                            text: "email_hint".tr,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "please Enter The Email".tr;
                              } else if (!value.isEmail) {
                                return "enter_validate_email".tr;
                              }
                              return null;
                            },
                          ),
                          30.heightBox,
                          MyField(
                            obscureText: true,
                            textInputType: TextInputType.visiblePassword,
                            text: "password_hint".tr,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "please enter the Password".tr;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                120.heightBox,
                MyButton(
                  width: Get.width * 0.9,
                  text: "Continue",
                  onPressed: () {},
                ),
                20.heightBox,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyTextButton(
                      text: "Forget Password?",
                      color: Colors.orange,
                    ),
                  ],
                )
              ],
            ).scrollVertical(),
          ),
        ),
      ),
    );
  }
}
