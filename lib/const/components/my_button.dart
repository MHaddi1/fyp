import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function? onPressed;
  final double? width;
  final double? height;
  const MyButton(
      {super.key,
      required this.text,
      this.onPressed,
      this.width = 300,
      this.height = 45});

  @override
  Widget build(BuildContext context) {
    return text.text
        .align(TextAlign.center)
        .color(Colors.white)
        .makeCentered()
        .box
        .size(width!, height!)
        .color(Colors.orange)
        .roundedSM
        .make()
        .onTap(() {
      onPressed;
    });
  }
}
