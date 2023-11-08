import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final bool isLoading; // Added to control the loading state
  const MyButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.width = 300,
    this.height = 45,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: text.text
          .align(TextAlign.center)
          .color(Colors.white)
          .makeCentered()
          .box
          .size(width!, height!)
          .color(Colors.orange)
          .roundedSM
          .make(),
    );
  }
}
