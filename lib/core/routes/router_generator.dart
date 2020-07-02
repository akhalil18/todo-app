import 'package:flutter/material.dart';

import '../../ui/screens/auth/login_screen.dart';
import '../../ui/screens/home_page/tasks_screen.dart';
import '../../ui/screens/splash_screen/splash_screen.dart';
import 'routing_constants.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case SplashScreenRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case LoginScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case TasksScreenRoute:
        return MaterialPageRoute(
            builder: (_) => TasksScreen(currentUser: args));

      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
