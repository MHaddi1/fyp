import 'package:flutter/material.dart';
import 'package:fyp/const/components/login/bottom_sheet.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:get/get.dart';

class SignView extends StatelessWidget {
  const SignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Get.offAndToNamed(RoutesName.suggestionScreen);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.orange,
            )),
      ),
      extendBody: true,
      body: const MyBottomLoginSheet(),
    );
  }
}
