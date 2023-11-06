import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SocialMedia extends StatelessWidget {
  final String text;
  final Color? color;
  final Function()? onPressed;
  final DecorationImage image;
  final double? width;
  final double? height;

  const SocialMedia({
    Key? key,
    required this.text,
    this.color,
    this.onPressed,
    required this.image,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color: color, boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: color,
                image: image,
              ),
            ),
            text.text.make().px8(),
          ],
        ),
      ),
    );
  }
}
