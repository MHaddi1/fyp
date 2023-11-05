import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class SocialMedia extends StatelessWidget {
  final String text;
  final Color? color;
  final Function()? onPressed;
  final DecorationImage image;
  final double? width;
  final double? height;

  SocialMedia({
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
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 8), // Add some spacing between text and image
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
