import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/controllers/sign_up_controller.dart';
import 'package:fyp/views/home/home_view.dart';
import 'package:fyp/views/login_view.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyView extends StatelessWidget {
  const MyView({super.key});

  @override
  Widget build(BuildContext context) {
    final SignUpController signUpController = Get.find<SignUpController>();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (firebaseAuth.currentUser != null &&
              firebaseAuth.currentUser!.emailVerified) ...[
            "You Email is Verifed".text.make(),
            MyButton(
              text: "Goto Home Page",
              onPressed: () {
                Get.offNamed(RoutesName.homeScreen);
              },
            )
          ] else
            MyButton(
              text: "Verify Email",
              onPressed: () async {
                await firebaseAuth.currentUser!.sendEmailVerification();
                // Wait for email verification
                await firebaseAuth.currentUser!.reload();

                if (firebaseAuth.currentUser!.emailVerified) {
                  Get.offNamed(RoutesName.homeScreen);
                } else {
                  // Handle the case where email verification fails
                  print("Email verification failed");
                }
              },
            ),
        ],
      ),
    ));
  }
}
