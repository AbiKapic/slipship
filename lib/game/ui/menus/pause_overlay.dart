import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/constants.dart';

/// Pause menu overlay
class PauseOverlay extends PositionComponent with HasGameRef {
  late final RectangleComponent _background;
  late final TextComponent _titleText;
  late final TextComponent _resumeText;
  late final TextComponent _quitText;
  
  PauseOverlay();
  
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
      paint: Paint()..color = Colors.black.withOpacity(0.7),
    );
    
    // Title
    _titleText = TextComponent(
      text: 'PAUSED',
      position: Vector2(
        size.x / 2,
        size.y / 2 - 100,
      ),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
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
    
    // Resume option
    _resumeText = TextComponent(
      text: 'Press P to Resume',
      position: Vector2(
        size.x / 2,
        size.y / 2,
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
        size.y / 2 + 50,
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
    add(_resumeText);
    add(_quitText);
  }
}
