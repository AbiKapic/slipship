import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:shipslip/app.dart';
import 'package:shipslip/dependencies.dart';
import 'package:shipslip/game/core/slip_ship_game.dart';

Future<void> runFlavoredApp(String environment) async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies(environment);

  runApp(const App());
}
