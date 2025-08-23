import 'package:flutter/material.dart';
import 'package:flame/game.dart' hide Route;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../game/ship_slip_game.dart';
import '../game/bloc/game_bloc.dart';

/// App routes
class AppRoutes {
  static const String home = '/';
  static const String play = '/play';
  
  /// Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainMenuScreen(),
        );
      case play:
        return MaterialPageRoute(
          builder: (_) => const GameScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const MainMenuScreen(),
        );
    }
  }
}

/// Main menu screen
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E3A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SNOW BRIDGE RUNNER',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(3, 3),
                    blurRadius: 6,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'A Puzzle Adventure',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.play);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              child: const Text(
                'PLAY',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'WASD to move, SPACE to pick up/drop',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Game screen with BLoC integration
class GameScreen extends StatelessWidget {
  const GameScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            GameWidget<ShipSlipGame>.controlled(
              gameFactory: ShipSlipGame.new,
            ),
            // Add pause button
            Positioned(
              top: 40,
              right: 20,
              child: SafeArea(
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


