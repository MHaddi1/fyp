import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final String? text;
  final String? image;
  final double? minWidth;
  final double? minHeight;

  const MyContainer(
      {super.key,
      required this.width,
      required this.height,
      this.color,
      this.text,
      this.image,
      this.minWidth,
      this.minHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: Colors.grey,
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              text!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
