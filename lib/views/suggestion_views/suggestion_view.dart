import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_container.dart';
import 'package:fyp/const/components/my_text_button.dart';
import 'package:fyp/const/images/app_image.dart';
import 'package:fyp/controllers/suggestion_controller.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class SuggestionView extends StatelessWidget {
  const SuggestionView({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestionController = Get.find<SuggestionController>();
    return Scaffold(
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
                height: suggestionController.videoController.value.size.height,
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
                "A²RI Craft".text.color(Colors.white).bold.xl4.make(),
                10.heightBox,
                "Tailor Service is.\nOn Demand"
                    .text
                    .justify
                    .bold
                    .color(Colors.white)
                    .xl2
                    .make(),
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
                        color: Colors.white,
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
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyTextButton(
                    text: "Sign In",
                    color: Colors.orange,
                  ),
                  MyTextButton(
                    text: "Skip",
                    color: Colors.orange,
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
                    text: "Tailor",
                    width: 150,
                    height: 150,
                    image: AppImage.mainImg,
                    minHeight: 30,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  MyContainer(
                    text: "Customer",
                    width: 150,
                    height: 150,
                    image: AppImage.coustomer,
                    minHeight: 30,
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
