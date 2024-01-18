import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String yourName;
  final void Function()? onPressed;
  final IconData? icon;

  const MyTextBox(
      {Key? key,
      required this.text,
      required this.yourName,
      required this.onPressed,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text.text.bold.size(16).color(textWhite).make(),
                IconButton(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  color: textWhite,
                ),
              ],
            ),
            const SizedBox(height: 8),
            yourName.text.size(18).color(textWhite).make(),
          ],
        ),
      ),
    );
  }
}
