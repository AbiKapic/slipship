import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shipslip/game/core/slip_ship_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: SlipShipGame(),
        loadingBuilder: (context) => const Center(child: CircularProgressIndicator()),
        errorBuilder: (context, error) => Center(child: Text('Error loading game: $error')),
      ),
    );
  }
}

