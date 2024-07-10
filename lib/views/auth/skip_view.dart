import 'package:flutter/material.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/social_media_button.dart';
import 'package:fyp/controllers/login_controller.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/views/auth/sign_up_view.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SkipView extends StatefulWidget {
  dynamic type;

  SkipView({super.key, this.type});

  @override
  State<SkipView> createState() => _SkipViewState();
}

class _SkipViewState extends State<SkipView> {
  @override
  Widget build(BuildContext context) {
    final _controllerLogin = Get.put(LoginController());
    var data = widget.type;
    print("type");
    print(data);

    // final _controllerSignup = Get.put(SignUpController());
    return Scaffold(
      backgroundColor: mainBack,
      body: Container(
        color: mainBack,
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
                    icon: const Icon(
                      Icons.close,
                      color: textWhite,
                    )),
                "Close".text.color(textWhite).make()
              ],
            ),
            20.heightBox,
            "title"
                .tr
                .text
                .xl3
                .bold
                .color(textWhite)
                .make()
                .box
                .alignCenterLeft
                .make(),
            20.heightBox,
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              "Join"
                  .text
                  .bold
                  .color(textWhite)
                  .xl2
                  .make()
                  .box
                  .alignTopLeft
                  .make(),
              10.widthBox,
              "title"
                  .tr
                  .text
                  .xl2
                  .color(textWhite)
                  .bold
                  .color(textWhite)
                  .make()
                  .box
                  .alignTopLeft
                  .make()
            ]),
            30.heightBox,
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed volutpat maximus placerat. Suspendisse potenti. Fusce velit risus, finibus quis risus et, malesuada viverra ex. Cras volutpat ante non lorem sollicitudin."
                .text
                .color(textWhite)
                .justify
                .make()
                .px8(),
            40.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SocialMedia(
                    onPressed: () {
                      _controllerLogin.signInWithGoogle(context);
                    },
                    color: Colors.white,
                    width: 40,
                    height: 40,
                    text: "google".tr,
                    image: const DecorationImage(
                        image: AssetImage(AppImage.google))),
                SocialMedia(
                    onPressed: () {
                      Get.to(
                        () => SignUpView(
                          type: widget.type,
                        ),
                      );
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
                "BY Joining, you agree to ".text.color(textWhite).make(),
                "title".tr.text.color(textWhite).make(),
                10.widthBox,
              ],
            ),
            "Term Of Service".text.color(mainColor).bold.make(),
          ],
        ).scrollVertical(),
      ).backgroundColor(Colors.white).px12(),
    );
  }
}
