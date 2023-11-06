import 'package:flutter/material.dart';
import 'package:fyp/const/components/login/bottom_sheet.dart';
import 'package:get/get.dart';

class SignView extends StatelessWidget {
  const SignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      extendBody: true,
      body: const MyBottomLoginSheet(),
    );
  }
}
