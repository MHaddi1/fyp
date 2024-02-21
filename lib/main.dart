import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/firebase_options.dart';
import 'package:get/get.dart';
import 'const/color.dart';
import 'const/localization/languages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'title'.tr,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      builder: EasyLoading.init(),
      initialRoute: RoutesName.splashScreen,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
