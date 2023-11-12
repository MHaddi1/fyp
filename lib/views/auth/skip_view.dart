import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/components/social_media_button.dart';
import 'package:fyp/views/auth/sign_up_view.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SkipView extends StatelessWidget {
  const SkipView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SizedBox(
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    color: Colors.white,
                    width: 40,
                    height: 40,
                    text: "facebook".tr,
                    image: const DecorationImage(
                        image: AssetImage(AppImage.facebook))),
                SocialMedia(
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
