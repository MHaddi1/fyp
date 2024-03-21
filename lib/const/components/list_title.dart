import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';

class MyListTitle extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final String scr;
  final double width;
  final double height;
  final void Function()? onPressed;
  const MyListTitle(
      {super.key,
      this.width = 24.0,
      this.height = 24.0,
      this.icon = Icons.abc,
      required this.text,
      required this.onPressed,
      this.color = textWhite,
      this.scr = ""});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        text,
        style: TextStyle(color: color),
      ),
      leading: icon != Icons.abc
          ? Icon(
              icon,
              color: color,
            )
          : Image.asset(
              scr, width: width, // Adjust the width as needed
              height: width, color: color,
            ),
    );
  }
}
