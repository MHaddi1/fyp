import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'home/home_view.dart';

class Cong extends StatelessWidget {
  const Cong({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset("assets/image/OrderPlaced.json"),
            SizedBox(
              height: 10.0,
            ),
            MyButton(
              text: "Close",
              onPressed: () {
                Get.offAll(() => HomeView());
              },
            )
          ],
        ),
      ),
    );
  }
}
