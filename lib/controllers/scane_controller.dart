// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:math';

// class ScaneController extends GetxController {
//   @override
//   void onInit() {
//     super.onInit();
//     initCamera();
//     initTFLite();
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   late CameraController cameraController;
//   late List<CameraDescription> camera;
//   RxBool isCameraInitialized = false.obs;
//   var cameraCount = 0;

//   initCamera() async {
//     if (await Permission.camera.request().isGranted) {
//       try {
//         camera = await availableCameras();
//         cameraController = CameraController(camera[0], ResolutionPreset.max);
//         await cameraController.initialize();
//         cameraController.startImageStream((image) {
//           cameraCount++;
//           if (cameraCount % 10 == 0) {
//             objectDetector(image);
//           }
//           update();
//         });
//         isCameraInitialized(true);
//         update();
//       } catch (e) {
//         print("Error initializing camera: $e");
//       }
//     } else {
//       print("Camera permission not granted");
//       // Handle case when camera permission is not granted (show message or ask the user to grant permission).
//     }
//     update();
//   }

//   initTFLite() async {
//     try {
//       await Tflite.loadModel(
//         model: "assets/tflite/models.tflite",
//         labels: "assets/tflite/labels.txt",
//         isAsset: true,
//         numThreads: 1,
//         useGpuDelegate: false,
//       );
//     } catch (e) {
//       print("Error initializing TensorFlow Lite model: $e");
//     }
//   }

//   objectDetector(CameraImage image) async {
//     try {
//       var detector = await Tflite.runModelOnFrame(
//         bytesList: image.planes.map((e) => e.bytes).toList(),
//         asynch: true,
//         imageHeight: image.height,
//         imageWidth: image.width,
//         imageMean: 127.5,
//         imageStd: 127.5,
//         numResults: 1,
//         rotation: 90,
//         threshold: 0.4,
//       );
//       if (detector != null) {
//         print("The Result is: $detector");
//         processBodyMeasurements(detector as Map<String, dynamic>);
//       }
//     } catch (e) {
//       print("Error running object detection: $e");
//     }
//   }

//   void processBodyMeasurements(Map<String, dynamic> detector) {
//     // Check if keypoint1 and keypoint2 are lists
//     if (detector['keypoint1'] is List<dynamic> &&
//         detector['keypoint2'] is List<dynamic>) {
//       // Assuming the lists contain x and y values
//       List<dynamic> keypoint1 = detector['keypoint1'];
//       List<dynamic> keypoint2 = detector['keypoint2'];

//       // Perform calculations using the list elements
//       if (keypoint1.length >= 2 && keypoint2.length >= 2) {
//         double distance = BodyMeasurementUtils.calculateDistance(
//           {'x': keypoint1[0], 'y': keypoint1[1]},
//           {'x': keypoint2[0], 'y': keypoint2[1]},
//         );

//         // Update UI or perform other actions based on the measurements
//         print("Distance: $distance");
//       }
//     } else {
//       // Handle the case when keypoint1 and keypoint2 are not lists
//       print("Invalid data format for keypoints");
//     }
//   }
// }

// class BodyMeasurementUtils {
//   static double calculateDistance(
//     Map<String, dynamic> keypoint1,
//     Map<String, dynamic> keypoint2,
//   ) {
//     double dx = keypoint2['x'] - keypoint1['x'];
//     double dy = keypoint2['y'] - keypoint1['y'];
//     return sqrt(dx * dx + dy * dy);
//   }

//   static double calculateAngle(
//     Map<String, dynamic> keypoint1,
//     Map<String, dynamic> keypoint2,
//     Map<String, dynamic> keypoint3,
//   ) {
//     double angleRadians = atan2(
//           keypoint3['y'] - keypoint2['y'],
//           keypoint3['x'] - keypoint2['x'],
//         ) -
//         atan2(
//           keypoint1['y'] - keypoint2['y'],
//           keypoint1['x'] - keypoint2['x'],
//         );
//     return angleRadians * (180 / pi); // Convert radians to degrees
//   }

//   static double calculateBodyRatio(
//     double height,
//     double width,
//   ) {
//     return height / width;
//   }

//   // Add more functions for different body measurements as needed
// }
