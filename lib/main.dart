import 'package:flutter/material.dart';
import 'package:shipslip/ui/screens/game_screen.dart';
import 'package:shipslip/ui/screens/loading_screen.dart';
import 'package:shipslip/ui/screens/puzzle_screen.dart';
import 'package:shipslip/ui/screens/start_screen.dart';

void main() {
  runApp(const ShipSlipApp());
}

class ShipSlipApp extends StatelessWidget {
  const ShipSlipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'shipslip',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      routes: {
        LoadingScreen.route: (context) => const LoadingScreen(),
        StartScreen.route: (context) => const StartScreen(),
        GameScreen.route: (context) => const GameScreen(),
        PuzzleScreen.route: (context) => const PuzzleScreen(),
      },
      initialRoute: LoadingScreen.route,
    );
  }
}
