import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/components/social_media_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/login_controller.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/views/auth/sign_up_view.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SkipView extends StatelessWidget {
  const SkipView({super.key});

  @override
  Widget build(BuildContext context) {
    final _controllerLogin = Get.put(LoginController());
    final _controllerSignup = Get.put(SignUpController());
    return Scaffold(
     
      body: SizedBox(
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            40.heightBox,
            Column(
              children: [
                IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close)),
                "Close".text.make()
              ],
            ),
            20.heightBox,
            "title".tr.text.xl3.bold.make().box.alignCenterLeft.make(),
            20.heightBox,
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              "Join".text.bold.xl2.make().box.alignTopLeft.make(),
              10.widthBox,
              "title".tr.text.xl2.bold.make().box.alignTopLeft.make()
            ]),
            30.heightBox,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed volutpat maximus placerat. Suspendisse potenti. Fusce velit risus, finibus quis risus et, malesuada viverra ex. Cras volutpat ante non lorem sollicitudin."
                .text
                .justify
                .make()
                .px8(),
            40.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SocialMedia(
                    onPressed: () {
                      _controllerLogin.googleSignIn();
                      Get.toNamed(RoutesName.signUpScreen2);
                    },
                    color: Colors.white,
                    width: 40,
                    height: 40,
                    text: "google".tr,
                    image: const DecorationImage(
                        image: AssetImage(AppImage.google))),
                SocialMedia(
                    onPressed: () {
                      Get.to(() => const SignUpView());
                    },
                    color: Colors.white,
                    width: 40,
                    height: 40,
                    text: "email".tr,
                    image: const DecorationImage(
                        image: AssetImage(AppImage.email))),
              ],
            ),
            30.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                "BY Joining, you agree to ".text.make(),
                "title".tr.text.make(),
                10.widthBox,
              ],
            ),
            "Term Of Service".text.color(Colors.orange).bold.make(),
          ],
        ).scrollVertical(),
      ).backgroundColor(Colors.white).px12(),
    );
  }
}
