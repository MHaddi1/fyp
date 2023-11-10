import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/const/components/social_media_button.dart';
import 'package:fyp/const/components/suggestions/my_text_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/login_controller.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/views/forget_password.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyBottomLoginSheet extends StatefulWidget {
  const MyBottomLoginSheet({super.key});

  @override
  State<MyBottomLoginSheet> createState() => _MyBottomLoginSheetState();
}

class _MyBottomLoginSheetState extends State<MyBottomLoginSheet> {
  final _controllerLogin = Get.put(LoginController());
  final key = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.addListener(() {
      final text = _emailController.text.toLowerCase();
      if (text != _emailController.text) {
        _emailController.value = _emailController.value.copyWith(
          text: text,
          selection: TextSelection(
            baseOffset: text.length,
            extentOffset: text.length,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                        onChanged: (value) {
                          _controllerLogin.setEmail(value!);
                        },
                        controller: _emailController,
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
                      Obx(
                        () => MyField(
                          onChanged: (value) {
                            _controllerLogin.setPassword(value!);
                          },
                          iconTap: () => _controllerLogin.showPassword(),
                          iconData: _controllerLogin.ispassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          controller: _passwordController,
                          obscureText: _controllerLogin.ispassword.value,
                          textInputType: TextInputType.visiblePassword,
                          text: "password_hint".tr,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "please enter the Password".tr;
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MyTextButton(
                            onPressed: () {
                              Get.to(() => const ForgetPassword());
                            },
                            text: "Forget Password?",
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            30.heightBox,
            Obx(
              () => MyButton(
                  isLoading: _controllerLogin.isLoading.value,
                  width: Get.width * 0.9,
                  text: "Continue",
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      key.currentState!.save();

                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await user.reload();
                        user = FirebaseAuth.instance.currentUser;

                        if (user!.emailVerified) {
                          _controllerLogin.login();
                        } else {
                          Utils.myBoxShow("Verified Email",
                              "Please verify your email first.");
                        }
                      }
                    }
                  }),
            ),
            20.heightBox,
            const Text(
              "or sign in with email",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SocialMedia(
                    color: Colors.white,
                    width: 50,
                    height: 50,
                    text: "Facebook",
                    image: const DecorationImage(
                        image: AssetImage(AppImage.facebook))),
                SocialMedia(
                    onPressed: () {
                      Get.defaultDialog(
                          title: "Google Sign in",
                          content: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          ));
                      _controllerLogin.googleSignIn().then((value) {
                        Get.back();
                        Get.toNamed(RoutesName.homeScreen);
                      });
                    },
                    color: Colors.white,
                    width: 30,
                    height: 30,
                    text: "Google",
                    image: const DecorationImage(
                        image: AssetImage(AppImage.google))),
              ],
            ),
          ],
        ).scrollVertical(),
      ),
    );
  }
}
