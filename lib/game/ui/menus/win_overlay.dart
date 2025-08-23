import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/constants.dart';

/// Win screen overlay
class WinOverlay extends PositionComponent with HasGameRef {
  late final RectangleComponent _background;
  late final TextComponent _titleText;
  late final TextComponent _statsText;
  late final TextComponent _restartText;
  late final TextComponent _quitText;
  
  WinOverlay();
  
  @override
  Future<void> onLoad() async {
    size = Vector2(
      GameConstants.baseDesignWidth,
      GameConstants.baseDesignHeight,
    );
    priority = GameConstants.zOverlay.toInt();
    
    // Semi-transparent background
    _background = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withOpacity(0.8),
    );
    
    // Title
    _titleText = TextComponent(
      text: 'LEVEL COMPLETE!',
      position: Vector2(
        size.x / 2,
        size.y / 2 - 120,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.yellow,
          fontSize: 48,
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
    
    // Stats
    _statsText = TextComponent(
      text: 'Press R to see stats',
      position: Vector2(
        size.x / 2,
        size.y / 2 - 40,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
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
    
    // Restart option
    _restartText = TextComponent(
      text: 'Press R to Restart',
      position: Vector2(
        size.x / 2,
        size.y / 2 + 20,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
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
    
    // Quit option
    _quitText = TextComponent(
      text: 'Press Q to Quit',
      position: Vector2(
        size.x / 2,
        size.y / 2 + 70,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
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
    add(_statsText);
    add(_restartText);
    add(_quitText);
  }
}
