import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player_component.dart';

/// Main game class for Ship Slip
class ShipSlipGame extends FlameGame with HasCollisionDetection {
  late PlayerComponent player;
  late SpriteComponent background;

  @override
  Color backgroundColor() => const Color(0xFF4A90E2);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    // Add background
    await _addBackground();

    // Add player
    await _addPlayer();

    // Add simple UI overlay
    await _addUI();
  }

  Future<void> _addBackground() async {
    // Create a simple gradient background
    background = SpriteComponent(
      size: size,
      paint: Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF87CEEB), // Sky blue
            const Color(0xFFFFFFFF), // White
            const Color(0xFF98FB98), // Pale green
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.x, size.y)),
    );
    add(background);
  }

  Future<void> _addPlayer() async {
    player = PlayerComponent(position: Vector2(size.x / 2, size.y / 2));
    add(player);
  }

  Future<void> _addUI() async {
    // Add game title
    final titleText = TextComponent(
      text: 'Ship Slip Game',
      position: Vector2(20, 20),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black),
          ],
        ),
      ),
    );
    add(titleText);

    // Add instructions
    final instructionsText = TextComponent(
      text: 'Use WASD or Arrow Keys to move',
      position: Vector2(20, size.y - 40),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          shadows: [
            Shadow(offset: Offset(1, 1), blurRadius: 2, color: Colors.black),
          ],
        ),
      ),
    );
    add(instructionsText);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _handleInput();
  }

  void _handleInput() {
    final keysPressed = HardwareKeyboard.instance.logicalKeysPressed;
    Vector2 direction = Vector2.zero();

    // WASD or Arrow key controls
    if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      direction.y -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      direction.y += 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      direction.x -= 1;
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      direction.x += 1;
    }

    if (direction != Vector2.zero()) {
      direction.normalize();
      player.move(direction);
    } else {
      player.stop();
    }
  }
}
