import 'package:flutter/material.dart';
import 'package:fyp/const/routes/routes.dart';
import 'package:fyp/const/routes/routes_name.dart';
import 'package:get/get.dart';
import 'const/localization/languages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: const Locale('ur', 'PK'),
      fallbackLocale: const Locale('ur', 'PK'),
      debugShowCheckedModeBanner: false,
      title: 'title'.tr,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: RoutesName.splashScreen,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
