import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/my_text_field.dart';
import 'package:fyp/const/components/social_media_button.dart';
import 'package:fyp/const/components/suggestions/my_text_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/login_controller.dart';
import 'package:fyp/services/auth/sign_services.dart';
import 'package:fyp/utils/utils.dart';
import 'package:fyp/views/auth/forget_password.dart';
import 'package:fyp/views/auth/login_view.dart';
import 'package:fyp/views/auth/suggestion_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
  final signinService = SignServices();
  bool isLoggedIn = false;
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
              onPressed: () {
                Get.offAndToNamed(RoutesName.suggestionScreen);
              },
              icon: const Icon(Icons.close, color: Colors.white)),
          "close".text.color(textWhite).make(),
          20.heightBox,
          "A²RI Craft"
              .text
              .color(textWhite)
              .bold
              .xl3
              .make()
              .box
              .alignBottomLeft
              .make(),
          20.heightBox,
          "Welcome Back!"
              .text
              .color(textWhite)
              .xl2
              .bold
              .make()
              .animatedBox
              .alignBottomLeft
              .make(),
          20.heightBox,
          "We welcome you into our A²RI Craft to build your carior!"
              .text
              .color(textWhite)
              .xl
              .make()
              .animatedBox
              .alignBottomLeft
              .make(),
          20.heightBox,
          Container(
            color: mainBack,
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
                          color: mainColor,
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
                        signinService.mySignIn(
                            _emailController.text, _passwordController.text);
                      } else {
                        Get.defaultDialog(
                            title: "Please Verify Your Email",
                            content: Lottie.asset(AppImage.mailCheck,
                                width: 150, height: 150),
                            middleText:
                                "Please verify your email by clicking on the verification link we have sent to your email. Once you have verified your email, you will be able to login",
                            confirm: ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Ok")));
                      }
                    }
                  }
                }),
          ),
          20.heightBox,
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Divider(
                color: textWhite,
              ),
              Text("Or", style: TextStyle(color: textWhite)),
              Divider(
                color: textWhite,
              ),
            ],
          ),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialMedia(
                  onPressed: () {
                    Get.defaultDialog(
                        title: "Google Sign in",
                        content: const Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        ));
                    _controllerLogin.signInWithGoogle(context).then((value) {
                      Get.offAndToNamed(RoutesName.homeScreen);
                    });
                    Get.back();
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
    );
  }
}
