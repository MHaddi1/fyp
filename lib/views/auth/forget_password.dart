import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final signUpController = Get.put(SignUpController());
  final _emailController = TextEditingController();
  final key = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.clear();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Form(
              key: key,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  Lottie.asset(AppImage.forgetPassword,
                      width: 200, height: 150),
                  20.heightBox,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      "please enter you email to"
                          .text
                          .xl
                          .color(Colors.grey[500])
                          .make()
                          .box
                          .alignCenterLeft
                          .make(),
                      "change your password"
                          .text
                          .xl2
                          .color(textWhite)
                          .make()
                          .box
                          .alignCenterLeft
                          .make()
                    ],
                  ),
                  10.heightBox,
                  MyField(
                      onChanged: (value) {
                        signUpController.setEmail(value!);
                      },
                      controller: _emailController,
                      text: "email_hint".tr,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return "email_hint".tr;
                        } else if (!value.isEmail) {
                          return "Enter a valid email";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            60.heightBox,
            MyButton(
              height: 50,
              width: Get.width,
              text: "Continue",
              onPressed: () {
                if (key.currentState!.validate()) {
                  key.currentState!.save();
                  signUpController.forgetPassword();
                }
              },
            ).box.make()
          ],
        ),
      ),
    );
  }
}
