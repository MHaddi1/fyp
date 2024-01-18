import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';

class MyContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final String? text;
  final String? image;
  final double? minWidth;
  final double? minHeight;
  final void Function() onPressed;

  const MyContainer(
      {super.key,
      required this.width,
      required this.height,
      this.color,
      this.text,
      this.image,
      this.minWidth,
      this.minHeight,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
          image: DecorationImage(
            image: AssetImage(image!),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: minHeight,
              width: minWidth,
              decoration: BoxDecoration(
                color: mainColor,
                border: Border.all(color: mainBack),
              ),
              child: Text(
                text!,
                style: const TextStyle(
                  color: textWhite,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
