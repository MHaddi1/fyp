import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/firebase_options.dart';
import 'package:fyp/views/auth/sign_up_view_2.dart';
import 'package:get/get.dart';
import 'const/localization/languages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseAppCheck.instance.activate();
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      // home: const InformationScreen(),
      initialRoute: RoutesName.splashScreen,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
