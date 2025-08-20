import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'dart:ui';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/services.dart';

enum PlayerAnimState { idleUp, idleDown, idleSide, walkUp, walkDown, walkSide }

class Player extends BodyComponent
    with ContactCallbacks, KeyboardHandler, HasGameRef<Forge2DGame> {
  Player({required this.joystickProvider});

  final JoystickComponent Function() joystickProvider;
  Vector2 initialPosition = Vector2.zero();

  final double radius = 24;
  final double moveForce = 70;
  final double maxSpeed = 240;

  // Damping to emulate friction:
  double normalDamping = 6.0; // snow
  double iceDamping = 0.6; // ice

  bool _onIce = false;
  final Vector2 _keyboardDirection = Vector2.zero();
  final Vector2 _lastNonZeroDir = Vector2(0, 1);
  late final SpriteAnimationGroupComponent<PlayerAnimState> _anim;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    gameRef.images.prefix = 'assets/images/';
    try {
      final image = await gameRef.images.load('movingcharacter.png');
      // Debug: confirm load and dimensions
      // ignore: avoid_print
      print('Loaded movingcharacter.png: \\${image.width}x\\${image.height}');

      final bool looksLike3x2 =
          (image.width % 3 == 0) && (image.height % 2 == 0);
      // ignore: avoid_print
      print('Detected layout: ' + (looksLike3x2 ? '3x2' : '2-and-4'));

      late final SpriteAnimation walkUp;
      late final SpriteAnimation idleUp;
      late final SpriteAnimation walkSide;
      late final SpriteAnimation idleSide;
      late final SpriteAnimation walkDown;
      late final SpriteAnimation idleDown;

      if (looksLike3x2) {
        // 3x2 grid (columns: 3, rows: 2)
        final frameSize = Vector2(image.width / 3, image.height / 2);
        final sheet = SpriteSheet(image: image, srcSize: frameSize);

        // Bottom row (1) as facing up; top row (0) as facing down
        walkUp = sheet.createAnimation(row: 1, from: 0, to: 2, stepTime: 0.12);
        idleUp = SpriteAnimation.spriteList([
          sheet.getSprite(1, 1),
        ], stepTime: 0.2);
        walkDown = sheet.createAnimation(
          row: 0,
          from: 0,
          to: 2,
          stepTime: 0.12,
        );
        idleDown = SpriteAnimation.spriteList([
          sheet.getSprite(0, 1),
        ], stepTime: 0.2);
        // Use row 1 frames for side movement too; flip X for left at runtime
        walkSide = sheet.createAnimation(
          row: 1,
          from: 0,
          to: 2,
          stepTime: 0.12,
        );
        idleSide = SpriteAnimation.spriteList([
          sheet.getSprite(1, 1),
        ], stepTime: 0.2);
      } else {
        // Irregular sheet: 2 frames on top row, 4 frames on second row
        const int rows = 2;
        final int rowHeight = (image.height / rows).floor();

        Sprite frameAt({
          required int row,
          required int col,
          required int colsInRow,
        }) {
          final int frameWidth = (image.width / colsInRow).floor();
          final int y = row * rowHeight;
          final int x = col * frameWidth;
          final int height = row == rows - 1 ? (image.height - y) : rowHeight;
          final int width = col == colsInRow - 1
              ? (image.width - x)
              : frameWidth;
          return Sprite(
            image,
            srcPosition: Vector2(x.toDouble(), y.toDouble()),
            srcSize: Vector2(width.toDouble(), height.toDouble()),
          );
        }

        // Top row (row 0): 2 frames (use as up/down alternately)
        walkDown = SpriteAnimation.spriteList([
          frameAt(row: 0, col: 0, colsInRow: 2),
          frameAt(row: 0, col: 1, colsInRow: 2),
        ], stepTime: 0.12);
        idleDown = SpriteAnimation.spriteList([
          frameAt(row: 0, col: 0, colsInRow: 2),
        ], stepTime: 0.2);
        walkUp = SpriteAnimation.spriteList([
          frameAt(row: 0, col: 1, colsInRow: 2),
          frameAt(row: 0, col: 0, colsInRow: 2),
        ], stepTime: 0.12);
        idleUp = SpriteAnimation.spriteList([
          frameAt(row: 0, col: 1, colsInRow: 2),
        ], stepTime: 0.2);

        // Second row (row 1): 4 frames for side-walk (right facing by default)
        walkSide = SpriteAnimation.spriteList([
          frameAt(row: 1, col: 0, colsInRow: 4),
          frameAt(row: 1, col: 1, colsInRow: 4),
          frameAt(row: 1, col: 2, colsInRow: 4),
          frameAt(row: 1, col: 3, colsInRow: 4),
        ], stepTime: 0.12);
        idleSide = SpriteAnimation.spriteList([
          frameAt(row: 1, col: 1, colsInRow: 4),
        ], stepTime: 0.2);
      }

      _anim = SpriteAnimationGroupComponent<PlayerAnimState>(
        animations: {
          PlayerAnimState.walkUp: walkUp,
          PlayerAnimState.idleUp: idleUp,
          PlayerAnimState.walkSide: walkSide,
          PlayerAnimState.idleSide: idleSide,
          PlayerAnimState.walkDown: walkDown,
          PlayerAnimState.idleDown: idleDown,
        },
        current: PlayerAnimState.idleDown,
        size: Vector2.all(radius * 2),
        anchor: Anchor.center,
        position: Vector2.zero(),
        priority: 10,
      );
      _anim.debugMode = false;
    } catch (e, st) {
      // ignore: avoid_print
      print('Failed to use movingcharacter.png, error: $e');
      // ignore: avoid_print
      print(st);
      final fallback = await gameRef.loadSprite('character.png');
      final single = SpriteAnimation.spriteList([fallback], stepTime: 0.2);
      _anim = SpriteAnimationGroupComponent<PlayerAnimState>(
        animations: {
          PlayerAnimState.walkUp: single,
          PlayerAnimState.idleUp: single,
          PlayerAnimState.walkSide: single,
          PlayerAnimState.idleSide: single,
          PlayerAnimState.walkDown: single,
          PlayerAnimState.idleDown: single,
        },
        current: PlayerAnimState.idleDown,
        size: Vector2.all(radius * 2),
        anchor: Anchor.center,
        position: Vector2.zero(),
        priority: 10,
      );
    }
    _anim.paint.filterQuality = FilterQuality.none;
    add(_anim);
    // Ensure player is rendered above background and areas
    priority = 100;
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final bool up =
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW);
    final bool down =
        keysPressed.contains(LogicalKeyboardKey.arrowDown) ||
        keysPressed.contains(LogicalKeyboardKey.keyS);
    final bool left =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA);
    final bool right =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD);

    _keyboardDirection
      ..setValues(0, 0)
      ..x = (right ? 1.0 : 0.0) + (left ? -1.0 : 0.0)
      ..y = (down ? 1.0 : 0.0) + (up ? -1.0 : 0.0);
    return true;
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = radius;
    final fixtureDef = FixtureDef(shape)
      ..density = 1.0
      ..friction = 0.2
      ..restitution = 0.0;
    final bodyDef = BodyDef()
      ..type = BodyType.dynamic
      ..position = initialPosition
      ..linearDamping = normalDamping
      ..fixedRotation = true;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  void setOnIce(bool onIce) {
    _onIce = onIce;
    body.linearDamping = _onIce ? iceDamping : normalDamping;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Read joystick once per frame; if joystick not attached yet, fallback
    Vector2 input = _keyboardDirection.clone();
    try {
      final joy = joystickProvider();
      if (joy.delta.length2 > 0) {
        input = joy.delta.clone();
      }
    } catch (_) {
      // joystick may not be ready yet; keep keyboard input
    }
    if (input.length2 > 0) {
      _lastNonZeroDir
        ..setFrom(input)
        ..normalize();
      input.normalize();
      body.applyForce(input * moveForce);
    }
    final v = body.linearVelocity;
    final speed = v.length;
    if (speed > maxSpeed) {
      body.linearVelocity = v.normalized()..scale(maxSpeed);
    }
    if (input.length2 > 0) {
      if (input.x.abs() > input.y.abs()) {
        _anim.current = PlayerAnimState.walkSide;
        _anim.scale.x = input.x < 0 ? -1 : 1;
      } else {
        _anim.scale.x = 1;
        _anim.current = input.y < 0
            ? PlayerAnimState.walkUp
            : PlayerAnimState.walkDown;
      }
    } else {
      if (_lastNonZeroDir.x.abs() > _lastNonZeroDir.y.abs()) {
        _anim.current = PlayerAnimState.idleSide;
        _anim.scale.x = _lastNonZeroDir.x < 0 ? -1 : 1;
      } else {
        _anim.scale.x = 1;
        _anim.current = _lastNonZeroDir.y < 0
            ? PlayerAnimState.idleUp
            : PlayerAnimState.idleDown;
      }
    }

    // Apply movement force every frame while input is present to ensure motion
    if (input.length2 > 0) {
      final Vector2 dir = input.clone()..normalize();
      body.applyForce(dir * moveForce);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
