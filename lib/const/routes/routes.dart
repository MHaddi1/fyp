import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/views/auth/sign_up_view_2.dart';
import 'package:fyp/views/home/home_view.dart';
import 'package:fyp/views/auth/login_view.dart';
import 'package:fyp/views/auth/skip_view.dart';
import 'package:fyp/views/no_internet.dart';
import 'package:fyp/views/splash_view.dart';
import 'package:fyp/views/auth/suggestion_view.dart';
import 'package:get/route_manager.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RoutesName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: RoutesName.suggestionScreen,
          page: () => const SuggestionView(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: RoutesName.signScreen,
          page: () => const SignView(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: RoutesName.skipScreen,
          page: () => const SkipView(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: RoutesName.homeScreen,
          page: () => HomeView(),
          transition: Transition.leftToRight,
        ),
        GetPage(
          name: RoutesName.signUpScreen2,
          page: () => const InformationScreen(),
          transition: Transition.leftToRight,
        ),
        GetPage(name: RoutesName.noInternet, page: () => NoInternet())
      ];
}
