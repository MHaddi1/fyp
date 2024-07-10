import 'package:flutter/material.dart';
import 'package:fyp/const/components/camera_view.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';


class Measurements extends GetView<HomeController> {
  const Measurements({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (context) {
      return CameraView(
        title: '',
        customPaint: controller.customPaint,
        text: controller.text,
        onImage: (inputImage) {
          controller.processImage(inputImage);
        },
      );
    });
  }
}
