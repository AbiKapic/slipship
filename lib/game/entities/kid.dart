import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

enum PlayerState { idleDown, idleUp, idleLeft, idleRight, walkLeft, walkRight, walkUp, walkDown }

class Kid extends SpriteAnimationGroupComponent<PlayerState>
    with HasGameReference, CollisionCallbacks {
  final double speed = 260;
  final Vector2 _move = Vector2.zero();
  PlayerState _facing = PlayerState.idleDown;
  bool _facingLeft = false;

  Kid() : super(anchor: Anchor.bottomCenter, priority: 10);

  @override
  Future<void> onLoad() async {
    final img = await game.images.load('players/kid_3x3.png');

    final frameW = img.width ~/ 3;
    final frameH = img.height ~/ 2;
    final scale = 0.154; // 0.32 * 0.7 = 30% smaller
    size = Vector2(frameW.toDouble() * 0.72, frameH.toDouble()) * scale;

    Sprite tile(int row, int col) {
      final double x = col * frameW.toDouble();
      final double y = row * frameH.toDouble();
      return Sprite(
        img,
        srcPosition: Vector2(x, y),
        srcSize: Vector2(frameW.toDouble(), frameH.toDouble()),
      );
    }

    final walkRight = SpriteAnimation.spriteList([tile(0, 1), tile(0, 2)], stepTime: 0.12);
    final walkLeft = walkRight;
    final walkDown = SpriteAnimation.spriteList([tile(1, 0), tile(1, 1)], stepTime: 0.12);
    final walkUp = SpriteAnimation.spriteList([tile(1, 2), tile(1, 2)], stepTime: 0.12);

    final idleDown = SpriteAnimation.spriteList([tile(1, 0)], stepTime: 1.0);
    final idleUp = SpriteAnimation.spriteList([tile(1, 2)], stepTime: 1.0);
    final idleRight = SpriteAnimation.spriteList([tile(0, 1)], stepTime: 1.0);
    final idleLeft = idleRight;

    animations = {
      PlayerState.walkRight: walkRight,
      PlayerState.walkLeft: walkLeft,
      PlayerState.walkUp: walkUp,
      PlayerState.walkDown: walkDown,
      PlayerState.idleDown: idleDown,
      PlayerState.idleUp: idleUp,
      PlayerState.idleRight: idleRight,
      PlayerState.idleLeft: idleLeft,
    };

    current = PlayerState.idleDown;

    add(
      RectangleHitbox(
        size: Vector2(size.x * 0.55, size.y * 0.6),
        position: Vector2(0, -size.y * 0.25),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_move.x == 0 && _move.y == 0) {
      switch (_facing) {
        case PlayerState.walkRight:
          current = PlayerState.idleRight;
          break;
        case PlayerState.walkLeft:
          current = PlayerState.idleLeft;
          break;
        case PlayerState.walkUp:
          current = PlayerState.idleUp;
          break;
        case PlayerState.walkDown:
          current = PlayerState.idleDown;
          break;
        default:
          current ??= PlayerState.idleDown;
      }
      return;
    }

    if (_move.x.abs() > _move.y.abs()) {
      if (_move.x > 0) {
        current = PlayerState.walkRight;
        _facing = PlayerState.walkRight;
        if (_facingLeft) {
          scale.x = 1;
          _facingLeft = false;
        }
      } else if (_move.x < 0) {
        current = PlayerState.walkLeft;
        _facing = PlayerState.walkLeft;
        if (!_facingLeft) {
          scale.x = -1;
          _facingLeft = true;
        }
      }
    } else {
      if (_move.y < 0) {
        current = PlayerState.walkUp;
        _facing = PlayerState.walkUp;
        if (_facingLeft) {
          scale.x = 1;
          _facingLeft = false;
        }
      } else if (_move.y > 0) {
        current = PlayerState.walkDown;
        _facing = PlayerState.walkDown;
        if (_facingLeft) {
          scale.x = 1;
          _facingLeft = false;
        }
      }
    }
  }

  void setDirection(Vector2 direction) {
    _move.setFrom(direction);
  }

  Vector2 get direction => _move.clone();
}
