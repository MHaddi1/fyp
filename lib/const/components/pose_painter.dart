import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import 'coordinate_translator.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.poses, this.absoluteImageSize, this.rotation);

  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.green;

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.yellow;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    for (final pose in poses) {
      pose.landmarks.forEach((_, landmark) {
        canvas.drawCircle(
          Offset(
            translateX(landmark.x, rotation, size, absoluteImageSize),
            translateY(landmark.y, rotation, size, absoluteImageSize),
          ),
          1,
          paint,
        );
      });

      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
          Offset(
            translateX(joint1.x, rotation, size, absoluteImageSize),
            translateY(joint1.y, rotation, size, absoluteImageSize),
          ),
          Offset(
            translateX(joint2.x, rotation, size, absoluteImageSize),
            translateY(joint2.y, rotation, size, absoluteImageSize),
          ),
          paintType,
        );
      }

      // Draw arms
      paintLine(
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftElbow,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.leftElbow,
        PoseLandmarkType.leftWrist,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightElbow,
        rightPaint,
      );
      paintLine(
        PoseLandmarkType.rightElbow,
        PoseLandmarkType.rightWrist,
        rightPaint,
      );

      // Draw Body
      paintLine(
        PoseLandmarkType.leftShoulder,
        PoseLandmarkType.leftHip,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.rightShoulder,
        PoseLandmarkType.rightHip,
        rightPaint,
      );

      // Draw legs
      paintLine(
        PoseLandmarkType.leftHip,
        PoseLandmarkType.leftAnkle,
        leftPaint,
      );
      paintLine(
        PoseLandmarkType.rightHip,
        PoseLandmarkType.rightAnkle,
        rightPaint,
      );

      // Calculate and display the distance between leftElbow and rightElbow
      final double shoulder = calculateDistance(
        pose.landmarks[PoseLandmarkType.leftShoulder]!,
        pose.landmarks[PoseLandmarkType.rightShoulder]!,
      );

      final double distance = calculateDistance(
        pose.landmarks[PoseLandmarkType.leftShoulder]!,
        pose.landmarks[PoseLandmarkType.leftElbow]!,
      );

      final TextPainter textPainter1 = TextPainter(
        text: TextSpan(
          text:
              'left to Right shoulder: ${shoulder.toStringAsFixed(2)}', // Format the distance as needed
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );

      final TextPainter textPainter2 = TextPainter(
        text: TextSpan(
          text:
              'left shoulder to elbo: ${shoulder.toStringAsFixed(2)}', // Format the distance as needed
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
        ),
        textDirection: TextDirection.ltr,
      );

      // textPainter1.layout();
      // textPainter1.paint(
      //   canvas,
      //   Offset(
      //     size.width / 2 - textPainter1.width / 2,
      //     size.height - 30, // Adjust the vertical position as needed
      //   ),
      // );

      textPainter2.layout();
      textPainter2.paint(
        canvas,
        Offset(
          size.width / 2 - textPainter2.width / 2,
          size.height - 30, // Adjust the vertical position as needed
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }

  double calculateDistance(PoseLandmark landmark1, PoseLandmark landmark2) {
    double distance = sqrt(
        pow(landmark2.x - landmark1.x, 2) + pow(landmark2.y - landmark1.y, 2));
    return distance;
  }
}
