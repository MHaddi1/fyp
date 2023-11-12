import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class MyIcons extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  final double? size;

  const MyIcons({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        size: size,
      ),
      title: text.text.make(),
    );
  }
}
