import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/constants.dart';

/// Main menu page
class MainMenuPage extends PositionComponent with HasGameRef {
  late final RectangleComponent _background;
  late final TextComponent _titleText;
  late final TextComponent _subtitleText;
  late final TextComponent _playText;
  late final TextComponent _instructionsText;
  
  MainMenuPage();
  
  @override
  Future<void> onLoad() async {
    size = Vector2(
      GameConstants.baseDesignWidth,
      GameConstants.baseDesignHeight,
    );
    priority = GameConstants.zOverlay.toInt();
    
    // Background
    _background = RectangleComponent(
      size: size,
      paint: Paint()..color = const Color(0xFF1E3A8A), // Dark blue
    );
    
    // Game title
    _titleText = TextComponent(
      text: 'SNOW BRIDGE RUNNER',
      position: Vector2(
        size.x / 2,
        size.y / 2 - 150,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
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
      anchor: Anchor.center,
    );
    
    // Subtitle
    _subtitleText = TextComponent(
      text: 'A Puzzle Adventure',
      position: Vector2(
        size.x / 2,
        size.y / 2 - 80,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.blue,
          fontSize: 24,
          fontWeight: FontWeight.normal,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: Colors.black,
            ),
          ],
        ),
      ),
      anchor: Anchor.center,
    );
    
    // Play button
    _playText = TextComponent(
      text: 'Press SPACE to Play',
      position: Vector2(
        size.x / 2,
        size.y / 2,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.green,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(2, 2),
              blurRadius: 4,
              color: Colors.black,
            ),
          ],
        ),
      ),
      anchor: Anchor.center,
    );
    
    // Instructions
    _instructionsText = TextComponent(
      text: 'WASD to move, SPACE to pick up/drop',
      position: Vector2(
        size.x / 2,
        size.y / 2 + 100,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.normal,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 2,
              color: Colors.black,
            ),
          ],
        ),
      ),
      anchor: Anchor.center,
    );
    
    add(_background);
    add(_titleText);
    add(_subtitleText);
    add(_playText);
    add(_instructionsText);
  }
}
