import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTextButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? color;
  const MyTextButton(
      {super.key, required this.text, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: text.text.color(color).make(),
    );
  }
}
