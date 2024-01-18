import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/assets/videos/app_videos.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/const/components/login/bottom_sheet.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/components/suggestions/my_container.dart';
import 'package:fyp/const/components/suggestions/my_text_button.dart';
import 'package:fyp/const/assets/images/app_image.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/suggestion_controller.dart';
import 'package:fyp/views/auth/skip_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class SuggestionView extends StatefulWidget {
  const SuggestionView({super.key});

  @override
  State<SuggestionView> createState() => _SuggestionViewState();
}

class _SuggestionViewState extends State<SuggestionView> {
  final suggestionController = Get.put(SuggestionController());

  @override
  void initState() {
    super.initState();
    // suggestionController.videoController = VideoPlayerController.asset(AppVideos.backgroundVideo);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    suggestionController.videoController.dispose();
    suggestionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackButtonPressed(context),
      child: Scaffold(
        backgroundColor: Colors.black12,
        body: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: suggestionController.videoController.value.size.width,
                  height:
                      suggestionController.videoController.value.size.height,
                  child: VideoPlayer(suggestionController.videoController),
                ),
              ),
            ),
            Container(color: Colors.black.withOpacity(0.5)),
            Positioned(
              bottom: 300,
              left: 20,
              child: VStack(
                [
                  "title".tr.text.color(textWhite).bold.xl4.make(),
                  10.heightBox,
                  "des".tr.text.justify.bold.color(textWhite).xl2.make(),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VStack(
                  [
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                          color: mainBack,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                    ),
                  ],
                )),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextButton(
                      text: "sign_in".tr,
                      color: mainColor,
                      onPressed: () async {
                        await Get.bottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            backgroundColor: mainBack,
                            barrierColor: mainColor,
                            isDismissible: false,
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 500),
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 500),
                            const MyBottomLoginSheet());
                      },
                    ),
                    MyTextButton(
                      text: "skip".tr,
                      color: mainColor,
                      onPressed: () async {
                        await Get.bottomSheet(
                            enableDrag: false,
                            isScrollControlled: true,
                            backgroundColor: mainBack,
                            barrierColor: mainColor,
                            isDismissible: false,
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 500),
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 500),
                            const SkipView());
                      },
                    )
                  ]).marginZero,
            ),
            Positioned(
                bottom: 90,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyContainer(
                      color: mainBack,
                      onPressed: () {
                        Get.bottomSheet(
                          isDismissible: false,
                          Container(
                            color: mainBack,
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    30.heightBox,
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: textWhite,
                                            ),
                                          ),
                                          5.heightBox,
                                          const Text(
                                            "Close",
                                            style: TextStyle(color: textWhite),
                                          ),
                                        ],
                                      ),
                                    ),
                                    20.heightBox,
                                    "Work Your way!"
                                        .text
                                        .bold
                                        .xl3
                                        .color(textWhite)
                                        .make()
                                        .box
                                        .alignCenterLeft
                                        .make(),
                                    10.heightBox,
                                    "Earning is not just about making money; it's about creating value."
                                        .text
                                        .color(textWhite)
                                        .make(),
                                    10.heightBox,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            "A Profile\nis bought"
                                                .text
                                                .color(textWhite)
                                                .make(),
                                            5.heightBox,
                                            "5 Sec"
                                                .text
                                                .color(mainColor)
                                                .bold
                                                .xl
                                                .make()
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            "A Price\nRange"
                                                .text
                                                .color(textWhite)
                                                .make(),
                                            5.heightBox,
                                            "10\$ to 10K\$"
                                                .text
                                                .color(mainColor)
                                                .bold
                                                .xl
                                                .make()
                                          ],
                                        ),
                                      ],
                                    ),
                                    10.heightBox,
                                    Row(
                                      children: [
                                        Lottie.asset(AppImage.profile,
                                            height: 70, width: 70),
                                        20.widthBox,
                                        Expanded(
                                          child: VStack(
                                            [
                                              "Create Profile"
                                                  .text
                                                  .color(textWhite)
                                                  .bold
                                                  .xl2
                                                  .make()
                                                  .box
                                                  .alignTopLeft
                                                  .make(),
                                              const Text(
                                                "Profile mirrors you; choose words for professionalism and authenticity.",
                                                style: TextStyle(
                                                  color: textWhite,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    20.heightBox,
                                    Row(
                                      children: [
                                        Lottie.asset(AppImage.delivery,
                                            height: 75, width: 75),
                                        20.widthBox,
                                        Expanded(
                                          child: Column(
                                            children: [
                                              VStack(
                                                [
                                                  "Fast Delivery"
                                                      .text
                                                      .color(textWhite)
                                                      .bold
                                                      .xl2
                                                      .make()
                                                      .box
                                                      .alignTopLeft
                                                      .make(),
                                                  const Text(
                                                    "Swift delivery builds trust, ensuring reliability and satisfaction in every transaction.",
                                                    style: TextStyle(
                                                      color: textWhite,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    20.heightBox,
                                    Row(
                                      children: [
                                        Lottie.asset(AppImage.getPaid,
                                            height: 70, width: 70),
                                        20.widthBox,
                                        Expanded(
                                          child: VStack(
                                            [
                                              "Get Paid"
                                                  .text
                                                  .color(textWhite)
                                                  .bold
                                                  .xl2
                                                  .make()
                                                  .box
                                                  .alignTopLeft
                                                  .make(),
                                              const Text(
                                                "Craft your GetPaid profile with words reflecting professionalism and authenticity.",
                                                style: TextStyle(
                                                  color: textWhite,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    20.heightBox,
                                    MyButton(
                                      text: "Continue",
                                      onPressed: () async {
                                        await Get.toNamed(
                                            RoutesName.skipScreen);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ignoreSafeArea: true,
                          barrierColor: mainColor,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          enterBottomSheetDuration:
                              const Duration(milliseconds: 500),
                          exitBottomSheetDuration:
                              const Duration(milliseconds: 500),
                          elevation: 3,
                        );
                      },
                      text: "tailor".tr,
                      width: 170,
                      height: 150,
                      image: AppImage.mainImg,
                      minHeight: 30,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                    MyContainer(
                      onPressed: () async {
                        await Get.bottomSheet(
                            enableDrag: false,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            barrierColor: mainColor,
                            isDismissible: false,
                            exitBottomSheetDuration:
                                const Duration(milliseconds: 500),
                            enterBottomSheetDuration:
                                const Duration(milliseconds: 500),
                            const SkipView());
                      },
                      text: "customer".tr,
                      width: 170,
                      height: 150,
                      image: AppImage.coustomer,
                      minHeight: 30,
                      minWidth: MediaQuery.of(context).size.width,
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Exit"),
            content: const Text("Are you sure you want to exit?"),
            actions: <Widget>[
              MyButton(
                text: "NO",
                onPressed: () {
                  Get.back(result: false);
                },
              ),
              10.heightBox,
              MyButton(
                  text: "Yes",
                  onPressed: () {
                    Get.back(result: true);
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  })
            ],
          );
        });

    return exitApp;
  }
}
