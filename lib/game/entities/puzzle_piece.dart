import 'dart:math';
import 'package:flame/components.dart';
import '../core/slip_ship_game.dart';
import '../entities/kid.dart';

class PuzzlePiece extends SpriteComponent with HasGameReference<SlipShipGame> {
  final int pieceIndex;
  final Kid player;
  
  double _bobOffset = 0.0;
  double _bobTime = 0.0;
  static const double _bobSpeed = 2.0;
  static const double _bobAmplitude = 8.0;
  static const double _followSpeed = 9.0;
  double _lastHorizontalSign = 1.0;

  PuzzlePiece({
    required this.pieceIndex,
    required this.player,
    required super.sprite,
  }) : super(
          anchor: Anchor.center,
          priority: 9,
        );

  @override
  Future<void> onLoad() async {
    size = Vector2(60, 60);
    scale = Vector2.all(0.6);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    _bobTime += dt * _bobSpeed;
    _bobOffset = _bobAmplitude * sin(_bobTime % (2 * pi));

    final dir = player.direction;
    if (dir.x.abs() > 0.15) {
      _lastHorizontalSign = dir.x >= 0 ? 1.0 : -1.0;
    }

    double offsetX;
    double offsetY;
    if (dir.x.abs() >= dir.y.abs() && dir.x.abs() > 0.1) {
      offsetX = (_lastHorizontalSign > 0 ? 1.0 : -1.0) * 42.0;
      offsetY = -12.0;
    } else {
      offsetX = (_lastHorizontalSign > 0 ? 1.0 : -1.0) * 36.0;
      offsetY = -12.0;
    }

    final targetX = player.position.x + offsetX;
    final targetY = player.position.y + offsetY + _bobOffset;
    final targetPosition = Vector2(targetX, targetY);

    final lerpFactor = _followSpeed * dt;
    position.x = position.x + (targetPosition.x - position.x) * lerpFactor;
    position.y = position.y + (targetPosition.y - position.y) * lerpFactor;
  }
}

