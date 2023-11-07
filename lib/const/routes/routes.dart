import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/views/home/home_view.dart';
import 'package:fyp/views/login/login_view.dart';
import 'package:fyp/views/skip/skip_view.dart';
import 'package:fyp/views/splash_view.dart';
import 'package:fyp/views/suggestion/suggestion_view.dart';
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
          page: () => const HomeView(),
          transition: Transition.leftToRight,
        ),
      ];
}
