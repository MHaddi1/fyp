import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/suggestion_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fyp/const/assets/images/app_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _textOpacity = 0.0;
  final suggestionController = Get.put(SuggestionController());

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _textOpacity = 1.0;
      });
    });
    Future.delayed(const Duration(seconds: 8), () {
      Get.toNamed(RoutesName.suggestionScreen);
      suggestionController.videoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: VStack(
        [
          Lottie.asset(
            AppImage.splashLogo,
            width: MediaQuery.of(context).size.width,
            height: 250,
          ),
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
