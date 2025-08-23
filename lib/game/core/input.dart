import 'package:flame/components.dart';

/// Input system for Snow Bridge Runner
class GameInput extends Component with HasGameRef {
  Vector2 _moveDirection = Vector2.zero();
  bool _actionPressed = false;

  // Getters for entities to read input
  Vector2 get moveDirection => _moveDirection;
  bool get actionPressed => _actionPressed;

  // Input state
  bool get isMoving => _moveDirection.length > 0.1;

  @override
  void update(double dt) {
    super.update(dt);
    // Reset action button each frame (it's a tap, not hold)
    _actionPressed = false;
  }

  /// Set movement direction from joystick
  void setMoveDirection(Vector2 direction) {
    _moveDirection = direction;

    // Normalize to unit vector
    if (_moveDirection.length > 1.0) {
      _moveDirection.normalize();
    }
  }

  /// Trigger action button (pickup/drop)
  void triggerAction() {
    _actionPressed = true;
  }

  /// Stop movement
  void stopMovement() {
    _moveDirection = Vector2.zero();
  }

  /// Get movement direction as normalized vector
  Vector2 get normalizedMoveDirection {
    if (_moveDirection.length < 0.1) return Vector2.zero();
    return _moveDirection.normalized();
  }

  /// Set input from keyboard (for testing)
  void setKeyboardInput({
    bool up = false,
    bool down = false,
    bool left = false,
    bool right = false,
  }) {
    _moveDirection = Vector2.zero();
    if (up) _moveDirection.y -= 1;
    if (down) _moveDirection.y += 1;
    if (left) _moveDirection.x -= 1;
    if (right) _moveDirection.x += 1;

    if (_moveDirection.length > 0) {
      _moveDirection.normalize();
    }
  }
}
