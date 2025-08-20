import 'package:flame/input.dart';
import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

/// Centralized input handling for the game
class InputHandler {
  late final JoystickComponent joystick;

  /// Creates and configures the joystick input
  JoystickComponent createJoystick(Vector2 screenSize) {
    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 18,
        paint: Paint()..color = const Color(0xFF00695C),
      ),
      background: CircleComponent(
        radius: 40,
        paint: Paint()..color = const Color(0x3300695C),
      ),
      margin: const EdgeInsets.only(left: 24, bottom: 24),
      position: Vector2(70, screenSize.y - 70),
      priority: 1000,
    );

    return joystick;
  }

  /// Gets the current joystick direction
  Vector2 getJoystickDirection() {
    return joystick.relativeDelta;
  }

  /// Checks if joystick is active
  bool get isJoystickActive => joystick.direction != Vector2.zero();
}
