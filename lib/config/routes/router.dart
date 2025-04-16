import 'package:flutter/material.dart';
import 'package:tree_app/config/routes/routes_path.dart';

import '../../features/get_started/ui/screens/get_start_screen.dart';


class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    // this argument is used to pass data from one screen to another
    final arguments = settings.arguments;
    switch (settings.name) {
      case RoutePath.getStarted:
        return MaterialPageRoute(
          builder: (_) => const GetStartScreen(),
        );

    }
    return null;
  }
}
