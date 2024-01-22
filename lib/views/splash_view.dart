import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:fyp/controllers/suggestion_controller.dart';
import 'package:fyp/services/splash_services.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fyp/const/assets/images/app_image.dart';

import '../services/auth/sign_up_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _textOpacity = 0.0;
  final suggestionController = Get.put(SuggestionController());
  final splashService = SplashServices();

  @override
  void initState() {
    super.initState();
    splashService.isLogin();
    // SignUpServices().currentCity();
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _textOpacity = 1.0;
        if (!kDebugMode) {
          suggestionController.videoController;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // suggestionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBack,
      body: VStack(
        [
          Image.asset(
            AppImage.logo,
            width: 200,
          ).box.alignCenter.color(Colors.white).size(200, 200).makeCentered(),
          20.heightBox,
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: _textOpacity),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: 'title'
                .tr
                .text
                .xl4
                .bold
                .color(const Color.fromARGB(255, 180, 106, 84))
                .makeCentered(),
          ),
        ],
      ).centered(),
    );
  }
}
