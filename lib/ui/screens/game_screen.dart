import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:shipslip/game/ship_slip_game.dart';
import 'package:shipslip/services/progress_service.dart';

class GameScreen extends StatefulWidget {
  static const String route = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ShipSlipGame _game;
  final ProgressService _progress = ProgressService();

  @override
  void initState() {
    super.initState();
    _game = ShipSlipGame(onLevelComplete: _onLevelComplete);
  }

  Future<void> _onLevelComplete() async {
    await _progress.addPiece();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/puzzle');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: GameWidget(game: _game)),
    );
  }
}
