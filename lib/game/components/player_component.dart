import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Simple player component for the game
class PlayerComponent extends CircleComponent {
  static const double playerRadius = 20.0;
  static const double speed = 200.0;
  
  late Vector2 _velocity;
  
  PlayerComponent({
    required Vector2 position,
  }) : super(
          radius: playerRadius,
          position: position,
          paint: Paint()..color = Colors.blue,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _velocity = Vector2.zero();
    
    // Add a white border
    add(CircleComponent(
      radius: playerRadius + 2,
      paint: Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += _velocity * dt;
    
    // Keep player within bounds
    _keepInBounds();
  }

  void move(Vector2 direction) {
    _velocity = direction * speed;
  }

  void stop() {
    _velocity = Vector2.zero();
  }

  void _keepInBounds() {
    final game = findGame();
    if (game == null) return;
    
    final gameSize = game.size;
    
    if (position.x < playerRadius) {
      position.x = playerRadius;
    } else if (position.x > gameSize.x - playerRadius) {
      position.x = gameSize.x - playerRadius;
    }
    
    if (position.y < playerRadius) {
      position.y = playerRadius;
    } else if (position.y > gameSize.y - playerRadius) {
      position.y = gameSize.y - playerRadius;
    }
  }
}
