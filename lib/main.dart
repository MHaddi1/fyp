import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fyp/const/localization/languages.dart';
import 'package:get/get.dart';
import 'const/routes/routes.dart';
import 'const/routes/routes_name.dart';
import 'const/color.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fyp/utils/check_internet_utils.dart';
import 'package:fyp/firebase_options.dart';

// Initialize Firebase Messaging
FirebaseMessaging messaging = FirebaseMessaging.instance;
List<CameraDescription> cameras = [];
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51P29RKJd5Hj3kQdBXWGvzYfAmkrHpIDA4KZVnyK2BJGoG1yAsGl8I5GDV2S0WymnApKXWyCtNleEDO9dMyFUCOfM00gy22LQtI";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize cameras
  cameras = await availableCameras();

  // Check internet connectivity
  bool isConnected = await ConnectivityUtil.instance.checkInternetConnection();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MyApp(
      isConnected: isConnected,
    ),
  );
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class MyApp extends StatelessWidget {
  final bool isConnected;

  const MyApp({
    required this.isConnected,
    Key? key,
  }) : super(key: key);

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
      builder: (context, child) {
        return FlutterEasyLoading(child: child);
      },
      initialRoute:
          isConnected ? RoutesName.splashScreen : RoutesName.noInternet,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
