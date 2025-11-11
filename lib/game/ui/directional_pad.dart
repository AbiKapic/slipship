import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DirectionalPad extends PositionComponent with HasGameReference {
  final Vector2 _direction = Vector2.zero();
  final Set<Direction> _pressedDirections = {};

  late final DirectionalButton _upButton;
  late final DirectionalButton _downButton;
  late final DirectionalButton _leftButton;
  late final DirectionalButton _rightButton;

  final double buttonSize = 45.0;
  final double padding = 6.0;

  Vector2 get direction => _direction.clone();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _upButton = DirectionalButton(
      direction: Direction.up,
      size: buttonSize,
      onPressed: _onDirectionPressed,
      onReleased: _onDirectionReleased,
    );
    _downButton = DirectionalButton(
      direction: Direction.down,
      size: buttonSize,
      onPressed: _onDirectionPressed,
      onReleased: _onDirectionReleased,
    );
    _leftButton = DirectionalButton(
      direction: Direction.left,
      size: buttonSize,
      onPressed: _onDirectionPressed,
      onReleased: _onDirectionReleased,
    );
    _rightButton = DirectionalButton(
      direction: Direction.right,
      size: buttonSize,
      onPressed: _onDirectionPressed,
      onReleased: _onDirectionReleased,
    );

    final centerX = buttonSize + padding;
    final centerY = buttonSize + padding;

    _upButton.position = Vector2(centerX, 0);
    _downButton.position = Vector2(centerX, centerY * 2);
    _leftButton.position = Vector2(0, centerY);
    _rightButton.position = Vector2(centerX * 2, centerY);

    addAll([_upButton, _downButton, _leftButton, _rightButton]);
  }

  void _onDirectionPressed(Direction direction) {
    _pressedDirections.add(direction);
    _updateDirection();
    _updateButtonStates();
  }

  void _onDirectionReleased(Direction direction) {
    _pressedDirections.remove(direction);
    _updateDirection();
    _updateButtonStates();
  }

  void _updateDirection() {
    _direction.setZero();

    if (_pressedDirections.contains(Direction.up)) {
      _direction.y -= 1;
    }
    if (_pressedDirections.contains(Direction.down)) {
      _direction.y += 1;
    }
    if (_pressedDirections.contains(Direction.left)) {
      _direction.x -= 1;
    }
    if (_pressedDirections.contains(Direction.right)) {
      _direction.x += 1;
    }

    if (_direction.length2 > 0) {
      _direction.normalize();
    }
  }

  void _updateButtonStates() {
    _upButton.setPressed(_pressedDirections.contains(Direction.up));
    _downButton.setPressed(_pressedDirections.contains(Direction.down));
    _leftButton.setPressed(_pressedDirections.contains(Direction.left));
    _rightButton.setPressed(_pressedDirections.contains(Direction.right));
  }
}

enum Direction { up, down, left, right }

class DirectionalButton extends PositionComponent with TapCallbacks {
  final Direction direction;
  final Function(Direction) onPressed;
  final Function(Direction) onReleased;
  
  bool _isPressed = false;

  DirectionalButton({
    required this.direction,
    required double size,
    required this.onPressed,
    required this.onReleased,
  }) : super(size: Vector2.all(size));

  void setPressed(bool pressed) {
    if (_isPressed != pressed) {
      _isPressed = pressed;
    }
  }

  @override
  bool onTapDown(TapDownEvent event) {
    onPressed(direction);
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    onReleased(direction);
    return true;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    onReleased(direction);
    return true;
  }

  @override
  void render(Canvas canvas) {
    final radius = size.x / 2;
    final center = Offset(radius, radius);

    final gradient = RadialGradient(
      colors: _isPressed
          ? [
              const Color(0xFF5A67D8),
              const Color(0xFF4C51BF),
              const Color(0xFF434190),
            ]
          : [
              const Color(0xFF667EEA),
              const Color(0xFF5A67D8),
              const Color(0xFF4C51BF),
            ],
      stops: const [0.0, 0.6, 1.0],
    );

    final buttonPaint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    canvas.drawCircle(center, radius + 2, shadowPaint);
    canvas.drawCircle(center, radius, buttonPaint);
    canvas.drawCircle(center, radius, borderPaint);

    final arrowSize = size.x * 0.4;
    final arrowPaint = Paint()
      ..color = Colors.white.withOpacity(_isPressed ? 1.0 : 0.9)
      ..style = PaintingStyle.fill;

    _drawArrow(canvas, center, arrowSize, arrowPaint);
  }

  void _drawArrow(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    
    switch (direction) {
      case Direction.up:
        path.moveTo(center.dx, center.dy - size / 2);
        path.lineTo(center.dx - size / 2, center.dy + size / 4);
        path.lineTo(center.dx + size / 2, center.dy + size / 4);
        path.close();
        break;
      case Direction.down:
        path.moveTo(center.dx, center.dy + size / 2);
        path.lineTo(center.dx - size / 2, center.dy - size / 4);
        path.lineTo(center.dx + size / 2, center.dy - size / 4);
        path.close();
        break;
      case Direction.left:
        path.moveTo(center.dx - size / 2, center.dy);
        path.lineTo(center.dx + size / 4, center.dy - size / 2);
        path.lineTo(center.dx + size / 4, center.dy + size / 2);
        path.close();
        break;
      case Direction.right:
        path.moveTo(center.dx + size / 2, center.dy);
        path.lineTo(center.dx - size / 4, center.dy - size / 2);
        path.lineTo(center.dx - size / 4, center.dy + size / 2);
        path.close();
        break;
    }
    
    canvas.drawPath(path, paint);
  }
}
