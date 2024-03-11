import 'package:flutter/material.dart';
import 'package:fyp/const/color.dart';
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
    this.height = 50,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: mainColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
              : Text(
            text,
            style: TextStyle(
              color: textWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
