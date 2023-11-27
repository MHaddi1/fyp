import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyp/const/components/login/bottom_sheet.dart';
import 'package:fyp/const/components/my_button.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class SignView extends StatelessWidget {
  const SignView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
      body: WillPopScope(
          onWillPop: () => _onBackButtonPressed(context),
          child: const MyBottomLoginSheet()),
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
