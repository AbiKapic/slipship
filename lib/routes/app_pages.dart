import 'package:flutter/material.dart';
import 'package:shipslip/features/game/screens/game_screen.dart';
import 'package:shipslip/features/initial/screens/initial_screen.dart';
import 'package:shipslip/routes/app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> routes = {
    AppRoutes.initial: (context) => const InitialScreen(),
    AppRoutes.game: (context) => const GameScreen(),
  };
}

