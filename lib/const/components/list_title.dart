import 'package:flutter/material.dart';

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
      title: Text(text),
      leading: Icon(icon),
    );
  }
}
