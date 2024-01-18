import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';

class MyListTitle extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onPressed;
  const MyListTitle(
      {super.key,
      required this.icon,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Text(
        text,
        style: TextStyle(color: textWhite),
      ),
      leading: Icon(
        icon,
        color: textWhite,
      ),
    );
  }
}
