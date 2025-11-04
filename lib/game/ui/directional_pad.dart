import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class DirectionalPad extends PositionComponent with HasGameReference {
  final Vector2 _direction = Vector2.zero();
  final Set<Direction> _pressedDirections = {};

  late final PositionComponent _upButton;
  late final PositionComponent _downButton;
  late final PositionComponent _leftButton;
  late final PositionComponent _rightButton;

  final double buttonSize = 60.0;
  final double padding = 8.0;

  Vector2 get direction => _direction.clone();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final buttonPaint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.6)
      ..style = PaintingStyle.fill;

    _upButton = _createButton(buttonPaint, Direction.up);
    _downButton = _createButton(buttonPaint, Direction.down);
    _leftButton = _createButton(buttonPaint, Direction.left);
    _rightButton = _createButton(buttonPaint, Direction.right);

    final centerX = buttonSize + padding;
    final centerY = buttonSize + padding;

    _upButton.position = Vector2(centerX, 0);
    _downButton.position = Vector2(centerX, centerY * 2);
    _leftButton.position = Vector2(0, centerY);
    _rightButton.position = Vector2(centerX * 2, centerY);

    addAll([_upButton, _downButton, _leftButton, _rightButton]);
  }

  PositionComponent _createButton(Paint buttonPaint, Direction dir) {
    return CircleComponent(
      radius: buttonSize / 2,
      paint: buttonPaint,
      children: [
        ButtonTapComponent(
          direction: dir,
          onPressed: _onDirectionPressed,
          onReleased: _onDirectionReleased,
          size: Vector2.all(buttonSize),
        ),
      ],
    );
  }

  void _onDirectionPressed(Direction direction) {
    _pressedDirections.add(direction);
    _updateDirection();
  }

  void _onDirectionReleased(Direction direction) {
    _pressedDirections.remove(direction);
    _updateDirection();
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
}

enum Direction { up, down, left, right }

class ButtonTapComponent extends RectangleComponent with TapCallbacks {
  final Direction direction;
  final Function(Direction) onPressed;
  final Function(Direction) onReleased;

  ButtonTapComponent({
    required this.direction,
    required this.onPressed,
    required this.onReleased,
    required Vector2 size,
  }) : super(size: size, paint: Paint()..color = Colors.transparent);

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
}
