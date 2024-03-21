import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/firebase_options.dart';
import 'package:fyp/utils/check_internet_utils.dart';
import 'package:get/get.dart';
import 'const/color.dart';
import 'const/localization/languages.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

bool delivered = false;
internetCheck() async {
  delivered = await ConnectivityUtil.instance.checkInternetConnection();
  return delivered;
}

List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  delivered = await internetCheck();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHander);
  runApp(const MyApp());
}

@pragma('vm-entry-point')
Future<void> _firebaseMessagingBackgroundHander(
    RemoteMessage remoteMessage) async {
  await Firebase.initializeApp();
  print(remoteMessage.notification?.title.toString());
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
      navigatorObservers: [
        if (!delivered) _InternetConnectionObserver(),
      ],
    );
  }
}

class _InternetConnectionObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is MaterialPageRoute && route is MaterialPageRoute) {
      if (route.settings.name != previousRoute.settings.name) {
        _showNoInternetSnackbar("Hello WordPress");
      }
    }
  }

  void _showNoInternetSnackbar(String routeName) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "No Internet Connection",
        "Please check your internet connection",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
    });
  }
}
