import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Skelton extends StatelessWidget {
  const Skelton({
    super.key,
    this.height,
    this.width,
  });
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Colors.black.withOpacity(0.5), // Customize overlay color and opacity
      child: Center(
          child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              strokeWidth:
                  8.0, // Adjust the thickness of the progress indicator
              semanticsLabel: 'Sign In', // Set a label for accessibility
            ),
            Text("Loading...")
          ],
        ),
      )),
    );
  }
}
