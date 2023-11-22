import 'package:flutter/material.dart';
import 'package:fyp/const/components/pose_painter.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../models/post_model.dart';
import '../services/post_services.dart';

class HomeController extends GetxController {
  final postServices = PostServices();
  final posts = <PostModel>[].obs;
  RxBool isLoading = false.obs;

  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? customPaint;
  String? text;
  //TODO: Implement HomeController

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _canProcess = false;
    _poseDetector.close();
    super.onClose();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;

    final poses = await _poseDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      text = 'Poses found: ${poses.length}\n\n';
      // TODO: set _customPaint to draw landmarks on top of image
      customPaint = null;
    }
    _isBusy = false;
    update();
  }

  fetchData() async {
    //final String collectionName = 'admin_Post';
    try {
      isLoading.value = true;
      final fetchedPosts = await postServices.getPosts("admin_Post");
      posts.addAll(fetchedPosts);
      print("Successfully fetched");
      print(posts);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
