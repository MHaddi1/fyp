import 'package:fyp/const/routes/routes_name.dart';
import 'package:fyp/views/splash_view.dart';
import 'package:fyp/views/suggestion_views/suggestion_view.dart';
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
      ];
}
